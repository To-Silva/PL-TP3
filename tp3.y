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
  Entry en;
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
%type <en> varEntry varMatrix
%%

program: declarations {fprintf(fp, "start\n");} statements {fprintf(fp, "stop\n");}
        ;

declarations: intDec ';' declarations
            |;


statements:
          statement statements
          |;

statement: varAssign ';'
          |WR STR ';'               {printf("string write\n");
                                     fprintf(fp, "\tpushs %s\n\twrites\n",$2);}

          |WR VAR ';'               {printf("write integer\n");
                                     fprintf(fp, "\tpushg %d \n\twritei\n",get_address(find_key(hashtable,$2)));}

          |WR varEntry '[' Exp ']' ';'   {printf("write integer[]\n");
                                          fprintf(fp, "\tloadn\n\twritei\n");}

          |WR varEntry '[' Exp ']' '[' Exp ']' ';'   {printf("write integer[]\n");
                                                       fprintf(fp, "\tloadn\n\twritei\n");}


          |RD ';'                   {printf("string read\n");
                                     fprintf(fp, "read\n atoi\n");}

          |ifBlock
          |whileBlock
          ;

ifBlock: ifStack '{' statements '}'                    {printf("if cond statements\n");
                                                        fprintf(fp,"if%d:\n\tnop\n",top_label(manager,If));
                                                        pop_label(manager,If);}

        | ifStack statement                           {printf("if cond statement\n");
                                                       fprintf(fp,"if%d:\n\tnop\n",top_label(manager,If));
                                                       pop_label(manager,If);}

        | ifStack '{' statements '}'   {push_label(manager,Else);
                                        fprintf(fp, "\tjump else%d\n",top_label(manager,Else));
                                        fprintf(fp,"if%d:\n\tnop\n",top_label(manager,If));
                                        pop_label(manager,If);}

                                        ELSE '{' statements '}'   {printf("if cond statements else statements\n");
                                                                   fprintf(fp,"else%d:\n\tnop\n",top_label(manager,Else));
                                                                   pop_label(manager,Else);}
        ;

ifStack: IF '(' condition ')'             {printf("ifstack\n");push_label(manager,If);
                                           fprintf(fp, "\tjz if%d\n",top_label(manager,If));}
        ;

whileBlock: whileStack '{' statements '}'                     {printf("while statements\n");
                                                               int i = top_label(manager,While);
                                                               fprintf(fp,"\tjump ciclo%d\nend%d:\n\tnop\n",i,i);
                                                               pop_label(manager,While);}

           |whileStack statement                              {printf("while\n");
                                                               int i = top_label(manager,While);
                                                               fprintf(fp,"\tjump ciclo%d\nend%d:\n\tnop\n",i,i);
                                                               pop_label(manager,While);}

           |DO {push_label(manager,DoWhile);
                fprintf(fp,"do%d:\n\tnop\n",top_label(manager,DoWhile));}

                '{' statements '}' WHILE '(' condition ')'                 {printf("do while\n");
                                                                            fprintf(fp,"\tnot\n\tjz do%d\n",top_label(manager,DoWhile));
                                                                            pop_label(manager,DoWhile);}
           ;

whileStack: {push_label(manager,While);
             fprintf(fp,"ciclo%d:\n\tnop\n",top_label(manager,While));}

             WHILE '(' condition ')'                                      {fprintf(fp,"\tjz end%d\n",top_label(manager,While));}
             ;

condition: comparison                                {printf("comparison\n");}
          |NOT condition                              {fprintf(fp,"\tnot\n");}
          |condition AND comparison                   {fprintf(fp,"\tmul\n");}
          |condition OR comparison                    {fprintf(fp,"\tadd\n");}
          ;

comparison: Exp EQ Exp                               {printf("eq between vars\n");fprintf(fp, "\tequal\n");}
          |Exp DIF Exp                               {printf("eq between vars\n");fprintf(fp, "\tequal\n\tpushi 1\n\tsub\n");}
          |Exp GT Exp                                {fprintf(fp, "\tsup\n");}
          |Exp LT Exp                                {fprintf(fp, "\tinf\n");}
          |Exp GTE Exp                               {fprintf(fp, "\tsupeq\n");}
          |Exp LTE Exp                               {fprintf(fp, "\tinfeq\n");}
          ;

Exp : value                           {$$=$1;}
    | Exp PLUS Exp                    {fprintf(fp,"\tadd\n");}
    | Exp MINUS Exp                   {fprintf(fp,"\tsub\n");}
    | Exp MUL Exp                     {fprintf(fp,"\tmul\n");}
    | Exp DIV Exp                     {fprintf(fp,"\tdiv\n");}
    | Exp MOD Exp                     {fprintf(fp,"\tmod\n");}
    | '(' Exp ')'                     {$$=$2;}
    ;

value: VAR                                          {$$.val=-1;$$.b=False;
                                                     Entry en=find_key(hashtable,$1);
                                                     if (en)
                                                       fprintf(fp,"\tpushg %d\n",get_address(en));
                                                     else
                                                       yyerror("undeclared variable");}

      | varEntry '[' Exp ']'                        {$$.val=-1;$$.b=False;
                                                     if (get_type($1)==Array){
                                                        fprintf(fp,"\tloadn\n");
                                                     }
                                                     else{printf("type mismatch %d\n",get_type($1));}}

      | varEntry '[' Exp ']' '[' Exp ']'            {$$.val=-1;$$.b=False;
                                                     if (get_type($1)==Array2D){
                                                        fprintf(fp,"\tloadn\n");
                                                     }
                                                     else{printf("type mismatch\n");}}

      |MINUS NUM                                    {$$.val=-$2;$$.b=True;
                                                     fprintf(fp,"\tpushi %d\n",-$2);}

      |NUM                                          {$$.val=$1;$$.b=True;
                                                     fprintf(fp,"\tpushi %d\n",$1);}
      ;

intDec:  INT VAR                                    {Entry en= new_entry_variable(new_int(manager),intVar);
                                                      if(add_key(&hashtable,$2,en)) {
                                                        fprintf(fp,"\tpushi 0\n");
                                                        printf("variable declaration\n");
                                                      }
                                                      else
                                                        yyerror("variable redeclaration");}

       | INT VAR '[' NUM ']'                        {Entry en= new_entry_array(new_array(manager,$4),Array,$4);
                                                     if(add_key(&hashtable,$2,en)) {
                                                        fprintf(fp,"\tpushn %d\n", get_sizex(en));
                                                        printf("array declaration\n");
                                                     }
                                                     else
                                                        yyerror("variable redeclaration");}

       | INT VAR '[' NUM ']' '[' NUM ']'            {Entry en= new_entry_matrix(new_matrix(manager,$4,$7),Array2D,$4,$7);
                                                     if(add_key(&hashtable,$2,en)) {
                                                        fprintf(fp,"\tpushn %d\n", get_sizexy(en));
                                                        printf("matrix declaration\n");
                                                     }
                                                     else
                                                        yyerror("variable redeclaration");}
       ;

varAssign:  VAR IS Exp                                 {printf("var value assign\n");
                                                        Entry en=find_key(hashtable,$1);
                                                        if (en)
                                                          fprintf(fp,"\tstoreg %d\n",get_address(en));
                                                        else
                                                          yyerror("undeclared variable");}

           |VAR IS RD                                  {printf("string read\n");
                                                        Entry en=find_key(hashtable,$1);
                                                        if (en)
                                                         {if (get_type(en)==intVar){
                                                           fprintf(fp, "\tread\n\tatoi\n\tstoreg %d\n",get_address(en));
                                                         }else{yyerror("type mismatch\n");}
                                                        }
                                                        else{yyerror("undeclared variable\n");}}

           |varEntry '[' Exp ']' IS Exp               {printf("array subscript value assign\n");
                                                       if (get_type($1)==Array){
                                                        fprintf(fp,"\tstoren\n");}
                                                       else{yyerror("type mismatch\n");}}

           |varEntry  '[' Exp ']' IS RD               {printf("array subscript assign read\n");
                                                       if (get_type($1)==Array){
                                                         fprintf(fp,"\tread\n\tatoi\n\tstoren\n");}
                                                       else{yyerror("type mismatch\n");}}

           |varMatrix IS Exp                          {printf("matrix subscript value assign\n");
                                                       fprintf(fp,"\tstoren\n");}

           |varMatrix IS RD                           {printf("matrix subscript assign read\n");
                                                       fprintf(fp,"\tread\n\tatoi\n\tstoren\n");}
           ;


varEntry: VAR  {$$=find_key(hashtable,$1);
                if ($$) {
                   fprintf(fp, "\tpushgp\n\tpushi %d\n\tpadd\n",get_address($$));
                 }
                else{yyerror("undeclared variable\n");}}
          ;


varMatrix: varEntry '[' Exp ']' '[' Exp ']' {$$=$1;
                                             if (get_type($1)==Array2D){
                                               fprintf(fp,"\tswap\n\tpushi %d\n\tmul\n\tadd\n",get_sizex($1));}
                                             else{yyerror("type mismatch\n");}}


%%
#include "lex.yy.c"
int main(int argc,char *argv[]){
  if(argc<2)
  {
    fp = fopen("output.vm","w");
  }
  else
  {
    fp = fopen(argv[1],"w");
  }
  manager=create_manager(JUMP_LABELS_MAX);
  yyparse();
  fclose(fp);
  return 0;
}

void yyerror(char *error){
  fprintf(stderr,"Line %d: %s %s\n",yylineno,yytext,error);
}
