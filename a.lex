%{
#include<malloc.h>
#include<stdlib.h>
#include<string.h>
#include"y.tab.h"
#include "symboltable.h"
#include <stack>
extern void yyerror(const char *);

stack<int> sk;
SymbolTable st;
%}
delim [ \t\n]
ws {delim}+
letter [A-Za-z_]
digit [0-9]
id {letter}({letter}|{digit})*
number {digit}+(\.{digit}+)?(E[+-]?{digit}+)?
%%
{ws} { }
"var" {return VAR;}
"integer" {return INTEGER;}
"real"    {return REAL;}
"then" {return THEN;}
"else" {return ELSE;}
"while" {return WHILE;}
"do"  {return DO;}
"begin" {return BEGIN1;}
"end" {return END;}
"if" {return IF;}
"epsilon" {return EPSILON;} //remove this line
{id} {strcpy(yylval.in.key,yytext);// st.insert(SymbolInfo(yylval.in.key,"identifier",""));
									return ID;}
{number} {strcpy(yylval.in.key,yytext); st.insert(SymbolInfo(yylval.in.key,"number",""));
								return NUMBER;}
";" {return SEMICOLON;}
"," {return COMMA;}
"(" {return LPAREN;}
")" {return RPAREN;}
":=" {return ASSIGNOP;}
"+" {return ADDOP;}
"-" {return SUBOP;}
"*" {return MULOP;}
":" {return COLON;}
"<" {strcpy(yylval.in.key,yytext);st.insert(SymbolInfo(yylval.in.key,"relop",""));return REL_OP;}
">" {strcpy(yylval.in.key,yytext);st.insert(SymbolInfo(yylval.in.key,"relop",""));return REL_OP;}
"<>" {strcpy(yylval.in.key,yytext);st.insert(SymbolInfo(yylval.in.key,"relop",""));return REL_OP;}
"<=" {strcpy(yylval.in.key,yytext);st.insert(SymbolInfo(yylval.in.key,"relop",""));return REL_OP;}
">=" {strcpy(yylval.in.key,yytext);st.insert(SymbolInfo(yylval.in.key,"relop",""));return REL_OP;}
"==" {strcpy(yylval.in.key,yytext);st.insert(SymbolInfo(yylval.in.key,"relop",""));return REL_OP;}
%%
int yywrap(void){
return 1;}
bool intost(SymbolInfo in)
{
	return st.insert(in);
}
void dump()
{
	st.dump();
}