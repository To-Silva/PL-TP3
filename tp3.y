%{
  #include <stdio.h>
  #include <string.h>
  #include "Entry.h"
  #include "Types.h"
  #include "HashTable.h"
  #include "Manager.h"
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
};
%token IF WHILE ELSE DO WR RD
%token NUM IS INT VAR STR
%left EQ DIF GT GTE LT LTE
%left NOT AND OR SEP
%left PLUS MINUS MUL DIV MOD
%right EXP
%type <i> NUM Exp
%type <s> STR VAR
%%

program: declarations statements
        ;

declarations: intDec ';' declarations
            |;


statements:
          statement statements
          |;

statement: varAssign ';'
          |WR STR ';'            {printf("string write\n");fprintf(fp, "pushs %s\nwrites\n",$2);}
          |WR VAR ';'            {printf("write integer\n");fprintf(fp, "pushg %d \nwrites\n",get_address(find_key(hashtable,$2)));}
          |RD ';'                {printf("string read\n");fprintf(fp, "read\n atoi\n");}
          |ifBlock
          |whileBlock
          ;

ifBlock: IF '(' condition ')' '{' statements '}'                           {printf("if cond statements\n");}
        |IF '(' condition ')' statement                                    {printf("if cond statement\n");}
        |IF '(' condition ')' '{' statements '}' ELSE '{' statements '}'   {printf("if cond statements else statements\n");}
        ;

whileBlock: WHILE '(' condition ')' '{' statements '}'                     {printf("while\n");}
           |WHILE '(' condition ')' statement                              {printf("while\n");}
           |DO '{' statements '}' WHILE '(' condition ')'
           ;

condition: comparison                                {printf("comparison\n");}
          |NOT condition
          |condition AND condition
          |condition OR condition
          ;

comparison: Exp EQ Exp                               {printf("eq between vars\n");}
          |Exp DIF Exp
          |Exp GT Exp
          |Exp LT Exp
          |Exp GTE Exp
          |Exp LTE Exp
          ;

Exp : value
    | Exp PLUS Exp
    | Exp MINUS Exp
    | Exp MUL Exp
    | Exp DIV Exp
    | Exp EXP Exp
    | Exp MOD Exp
    | '(' Exp ')'
    ;

value: VAR
      |MINUS NUM
      |NUM
      ;

intDec:  INT VAR                                    { Entry e= new_entry_variable(new_int(manager),intVar);
                                                      if(add_key(&hashtable,$2,e)) {
                                                        printf("pushi 0\n");
                                                        printf("variable declaration\n");
                                                      } else {
                                                        yyerror("variable redeclaration");
                                                      }}
       | INT VAR '[' Exp ']'                        {Entry e= new_entry_variable(new_array(manager,$4),intVar);
                                                     if(add_key(&hashtable,$2,e)) {
                                                        printf("pushn %d\n", get_sizex(e));
                                                        printf("array declaration\n");
                                                     } else {
                                                        yyerror("variable redeclaration");
                                                     }}
       | INT VAR '[' Exp ']' '[' Exp ']'            {Entry e= new_entry_variable(new_matrix(manager,$4,$7),intVar);
                                                     if(add_key(&hashtable,$2,e)) {
                                                        printf("pushn %d\n", get_sizexy(e));
                                                        printf("matrix declaration\n");
                                                     } else {
                                                        yyerror("variable redeclaration");
                                                     }}
       ;

varAssign:  VAR IS Exp                                 {printf("var value assign\n");}
           |VAR IS '[' numList ']'                     {printf("array value assign\n");}
           |VAR IS '[' numList ']' '[' numList ']'     {printf("array 2D value assign\n");}
           |VAR IS RD ';'                              {printf("string read\n");fprintf(fp, "read atoi\n");}
           |VAR '[' Exp ']' IS Exp
           |VAR '[' Exp ']' IS RD ';'                  {printf("array subscript assign read")}
           |VAR '[' Exp ']' IS '[' numList ']'
           |VAR '[' Exp ']' '[' Exp ']' IS Exp
           |VAR '[' Exp ']' '[' Exp ']' IS RD ';'
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
