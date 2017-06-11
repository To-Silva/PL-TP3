%{
  #include <stdio.h>
  #include <string.h>
  #include "Entry.h"
  #include "Types.h"
  #include "HashTable.h"
  char *names;
  int *values;
  int yylex();
  void yyerror(char*);
  static FILE *fp;
  static HashTable hashtable;
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
%type <i> NUM
%type <s> VAR STR
%%

program: declarations statements
        ;

declarations: intDec ';' declarations
            |;


statements:
          statement statements
          |;

statement:VAR varAssign ';'
          |VAR '[' Exp ']' varAssign ';'
          |WR STR ';'            {printf("string write\n");fprintf(fp, "pushs %s\nwrites\n",$2);}
          |RD ';'                {printf("string read\n");fprintf(fp, "read atoi\n");}
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

intDec:  INT VAR                                    {printf("var declaration\n");}
       | INT VAR '[' Exp ']'                        {printf("array declaration\n");}
       | INT VAR '[' Exp ']' '[' Exp ']'            {printf("array 2D declaration\n");}
       | INT VAR varAssign                          {printf("var declaration and value assign\n");}
       | INT VAR '[' Exp ']' varAssign              {printf("array declaration and value assign\n");}
       | INT VAR '[' Exp ']' '[' Exp ']' varAssign  {printf("array 2D declaration and value assign\n");}
       ;

varAssign:   IS Exp                                 {printf("var value assign\n");}
           | IS '[' numList ']'                     {printf("array value assign\n");}
           | IS '[' numList ']' '[' numList ']'     {printf("array 2D value assign\n");}
           ;

numList: Exp                                     {printf("number of list\n");}
        |numList SEP numList                     {printf("two numbers of list\n");}
        ;

%%
#include "lex.yy.c"
int main(int argc,char *argv[]){

  fp = fopen("output.vm","w");
  yyparse();
  fclose(fp);
  return 0;
}

void yyerror(char *error){
  fprintf(stderr,"Line %d: %s %s\n",yylineno,yytext,error);
}
