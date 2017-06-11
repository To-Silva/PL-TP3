%{
  #include <stdio.h>
  #include <string.h>
  #include "Entry.h"
  #include "Types.h"
  #include "HashTable.h"
  #include "Manager.h"
  typedef enum _boolean
  {
    True,
    False
  } boolean;
  static char *names;
  static int *values;
  static FILE *fp;
  static HashTable hashtable;
  static Manager manager;
  int yylex();
  void yyerror(char*);
%}
%union{
  char *s;
  int i;
  struct value
  {
    int val;
    boolean b;
  } s_val;
};
%token IF WHILE ELSE DO WR RD
%token NUM IS INT VAR STR
%left EQ DIF GT GTE LT LTE
%left NOT AND OR SEP
%left PLUS MINUS MUL DIV MOD
%right EXP
%type <i> NUM
%type <s> STR VAR
%type <s_val> Exp value
%%

program: declarations {fprintf(fp, "start\n");} statements {fprintf(fp, "stop\n");}
        ;

declarations: intDec ';' declarations
            |;


statements:
          statement statements
          |;

statement: varAssign ';'
          |WR STR ';'            {printf("string write\n");fprintf(fp, "\tpushs %s\n\twrites\n",$2);}
          |WR VAR ';'            {printf("write integer\n");fprintf(fp, "\tpushg %d \n\twrites\n",get_address(find_key(hashtable,$2)));}
          |RD ';'                {printf("string read\n");fprintf(fp, "read\n atoi\n");}
          |ifBlock
          |whileBlock
          ;

ifBlock: IF '(' condition ')'

                              {push_label(manager,If);
                               fprintf(fp, "\tjz if%d\n",top_label(manager,If));}

                             '{' statements '}'                            {printf("if cond statements\n");
                                                                            fprintf(fp,"if%d:nop\n",top_label(manager,If));
                                                                            pop_label(manager,If);}

        |IF '(' condition ')'

                              {push_label(manager,If);
                               fprintf(fp, "\tjz if%d\n",top_label(manager,If));}

                                       statement                           {printf("if cond statement\n");
                                                                            fprintf(fp,"if%d:nop\n",top_label(manager,If));
                                                                            pop_label(manager,If);}

        |IF '(' condition ')'

                            {push_label(manager,If);
                             fprintf(fp, "\tjz if%d\n",top_label(manager,If));}

                                '{' statements '}'   {push_label(manager,Else);
                                                      fprintf(fp, "\tjz else%d\n",top_label(manager,Else));
                                                      fprintf(fp,"if%d:\n\tnop\n",top_label(manager,If));
                                                      pop_label(manager,If);}

                                                      ELSE '{' statements '}'   {printf("if cond statements else statements\n");
                                                                                 fprintf(fp,"else%d:\n\tnop\n",top_label(manager,Else));
                                                                                 pop_label(manager,Else);}
        ;

whileBlock: {push_label(manager,While);
             fprintf(fp,"ciclo%d:\n\tnop\n",top_label(manager,While));}

             WHILE '(' condition ')' {fprintf(fp,"\tjz end%d\n",top_label(manager,While));}

                                    '{' statements '}'                     {printf("while statements\n");
                                                                            fprintf(fp,"\tjmp ciclo%d\n",top_label(manager,While));
                                                                            pop_label(manager,While);}

           |{push_label(manager,While);
                        fprintf(fp,"ciclo%d:\n\tnop\n",top_label(manager,While));}

            WHILE '(' condition ')' {fprintf(fp,"\tjz end%d\n",top_label(manager,While));}

                                   statement                              {printf("while\n");
                                                                           fprintf(fp,"\tjmp ciclo%d\n",top_label(manager,While));
                                                                           pop_label(manager,While);}
           |DO {push_label(manager,DoWhile);
                fprintf(fp,"do%d:\n\tnop\n",top_label(manager,DoWhile));}

                '{' statements '}' WHILE '(' condition ')'                 {printf("do while\n");
                                                                            fprintf(fp,"\tnot\n\tjz do%d\n",top_label(manager,DoWhile));
                                                                            pop_label(manager,DoWhile);}
           ;

condition: comparison                                {printf("comparison\n");}
          |NOT condition                              {fprintf(fp,"\tnot\n");}
          |condition AND comparison                   {fprintf(fp,"\tmul\n");}
          |condition OR comparison                    {fprintf(fp,"\tadd\n");}
          ;

comparison: Exp EQ Exp                               {printf("eq between vars\n");fprintf(fp, "\tequal\n");}
          |Exp DIF Exp                               {printf("eq between vars\n");fprintf(fp, "\tequal\n\tnot\n");}
          |Exp GT Exp                                {fprintf(fp, "\tsup\n");}
          |Exp LT Exp                                {fprintf(fp, "\tinf\n");}
          |Exp GTE Exp                               {fprintf(fp, "\tsupeq\n");}
          |Exp LTE Exp                               {fprintf(fp, "\tinfeq\n");}
          ;

Exp : value
    | Exp PLUS Exp                    {fprintf(fp,"\tadd\n");}
    | Exp MINUS Exp                   {fprintf(fp,"\tsub\n");}
    | Exp MUL Exp                     {fprintf(fp,"\tmul\n");}
    | Exp DIV Exp                     {fprintf(fp,"\tdiv\n");}
    | Exp MOD Exp                     {fprintf(fp,"\tmod\n");}
    | '(' Exp ')'
    ;

value: VAR                                          {$$.val=-1;$$.b=False;Entry en; en=find_key(hashtable,$1);
                                                                           if (en)
                                                                           {fprintf(fp,"\tpushg %d\n",get_address(en));}
                                                                           else{yyerror("undeclared variable");}}
      |MINUS NUM                                    {$$.val=-$2;$$.b=True;fprintf(fp,"\tpushi -%d\n",$2);}
      |NUM                                          {$$.val=$1;$$.b=True;fprintf(fp,"\tpushi %d\n",$1);}
      ;

intDec:  INT VAR                                    { Entry e= new_entry_variable(new_int(manager),intVar);
                                                      if(add_key(&hashtable,$2,e)) {
                                                        fprintf(fp,"\tpushi 0\n");
                                                        printf("variable declaration\n");
                                                      } else {
                                                        yyerror("variable redeclaration");
                                                      }}
       | INT VAR '[' Exp ']'                        {Entry e= new_entry_variable(new_array(manager,$4.val),intVar);
                                                     if(add_key(&hashtable,$2,e)) {
                                                        fprintf(fp,"\tpushn %d\n", get_sizex(e));
                                                        printf("array declaration\n");
                                                     } else {
                                                        yyerror("variable redeclaration");
                                                     }}
       | INT VAR '[' Exp ']' '[' Exp ']'            {Entry e= new_entry_variable(new_matrix(manager,$4.val,$7.val),intVar);
                                                     if(add_key(&hashtable,$2,e)) {
                                                        fprintf(fp,"\tpushn %d\n", get_sizexy(e));
                                                        printf("matrix declaration\n");
                                                     } else {
                                                        yyerror("variable redeclaration");
                                                     }}
       ;

varAssign:  VAR IS Exp                                 {printf("var value assign\n");Entry en; en=find_key(hashtable,$1);if (en)
                                                                           {fprintf(fp,"\tstoreg %d\n",get_address(en));}
                                                                           else{yyerror("undeclared variable");}}
           |VAR IS '[' numList ']'                     {printf("array value assign\n");Entry en; en=find_key(hashtable,$1);
                                                                                     if (en)
                                                                                      {if (get_type(en)==Array){

                                                                                        }else{yyerror("type mismatch\n");}
                                                                                      }
                                                                                      else{yyerror("undeclared variable\n");}}
           |VAR IS '[' numList ']' '[' numList ']'     {printf("array 2D value assign\n");Entry en; en=find_key(hashtable,$1);
                                                                                     if (en)
                                                                                      {if (get_type(en)==Array2D){
                                                                                        fprintf(fp,"\tstoreg %d\n",get_address(en));
                                                                                        }else{yyerror("type mismatch\n");}
                                                                                      }
                                                                                      else{yyerror("undeclared variable\n");}}
           |VAR IS RD                                  {printf("string read\n");Entry en; en=find_key(hashtable,$1);
                                                                                     if (en)
                                                                                      {if (get_type(en)==intVar){
                                                                                        fprintf(fp, "\tread\n\tatoi\n\tstoreg %d\n",get_address(en));
                                                                                      }else{yyerror("type mismatch\n");}
                                                                                     }
                                                                                     else{yyerror("undeclared variable\n");}}
           |VAR {Entry en; en=find_key(hashtable,$1);
                 if (en)
                  {if (get_type(en)==intVar){
                    fprintf(fp, "\tpushgp\n\tpushi %d\n\tpadd\n",get_address(en));
                  }else{yyerror("type mismatch\n");}
                 }
                 else{yyerror("undeclared variable\n");}} '[' Exp ']' IS Exp {fprintf(fp,"\tstoren\n");}
           |VAR {Entry en; en=find_key(hashtable,$1);
                 if (en)
                  {if (get_type(en)==intVar){
                    fprintf(fp, "\tpushgp\n\tpushi %d\n\tpadd\n",get_address(en));
                  }else{yyerror("type mismatch\n");}
                 }
                 else{yyerror("undeclared variable\n");}}'[' Exp ']' IS RD ';'         {printf("array subscript assign read");fprintf(fp,"\tread\n\tatoi\n\tstoren\n");}
           |VAR {Entry en; en=find_key(hashtable,$1);
                 if (en)
                  {if (get_type(en)==intVar){
                    fprintf(fp, "\tpushgp\n\tpushi %d\n\tpadd\n",get_address(en));
                  }else{yyerror("type mismatch\n");}
                 }
                 else{yyerror("undeclared variable\n");}}'[' Exp ']' IS '[' numList ']'
           |VAR {Entry en; en=find_key(hashtable,$1);
                 if (en)
                  {if (get_type(en)==intVar){
                    fprintf(fp, "\tpushgp\n\tpushi %d\n\tpadd\n",get_address(en));
                  }else{yyerror("type mismatch\n");}
                 }
                 else{yyerror("undeclared variable\n");}}'[' Exp ']' '[' Exp ']' IS Exp  {fprintf(fp,"\tswap\n\tpushsp\n\tpushi -2\n\tpadd\n\tload 0\n\tpushi 1\n\tsub\n\tmul\n\tadd");}
           |VAR {Entry en; en=find_key(hashtable,$1);
                 if (en)
                  {if (get_type(en)==intVar){
                    fprintf(fp, "\tpushgp\n\tpushi %d\n\tpadd\n",get_address(en));
                  }else{yyerror("type mismatch\n");}
                 }
                 else{yyerror("undeclared variable\n");}} '[' Exp ']' '[' Exp ']' IS RD ';'
           ;

numList: Exp                                     {printf("number of list\n");}
        |numList SEP numList                     {printf("two numbers of list\n");}
        ;

%%
#include "lex.yy.c"
int main(int argc,char *argv[]){

  fp = fopen("output.vm","w");
  manager=create_manager(JUMP_LABELS_MAX);
  yyparse();
  fclose(fp);
  return 0;
}

void yyerror(char *error){
  fprintf(stderr,"Line %d: %s %s\n",yylineno,yytext,error);
}
