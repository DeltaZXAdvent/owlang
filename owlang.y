%{
	#include <stdio.h>
	int yylex(void);
	void yyerror(const char *);
%}

%token CHAR
%token SUB
%token BUS
%token ID
%token LPAREN
%token RPAREN
%token COMMA

%%

input:
     %empty
|    input str
|    input SUB ID block BUS
;

block:
     %empty
|    block str
|    block call
;

call:
    ID '(' @@@

str:
   CHAR
|  str CHAR
;
