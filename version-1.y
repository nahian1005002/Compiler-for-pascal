%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<string>
using namespace std;

void yyerror(const char *s);
extern int yylex();


char id[1000]="";
char label[10]="" ;
char if_lbl[100]=" ";
char lblwhile[10]=" ";
char templabel[10]=" ";

int temp_num;
int temp_var_num;


void newLabel()
{
	char lb[4]="L";
	char b[10];
	itoa(temp_num++,b,10);
	strcat(lb,b);
	strcpy(label,lb);
}

void temp()
{
	char lb[4]="T";
	char b[10];
	itoa(temp_var_num++,b,10);
	strcat(lb,b);
	strcpy(templabel,lb);
	strcat(id,templabel);
	strcat(id," dw 0\n");
}

%}


%union { 
struct symbolInfo
  {
	char key[20];
	char type[20];
	char code[5000];
  }in;
}


%token 	EPSILON VAR INTEGER BEGIN1 END ASSIGNOP ADDOP MULOP LPAREN RPAREN COMMA COLON SEMICOLON IF THEN ELSE WHILE DO SUBOP

%token <in> ID
%token <in> NUMBER
%token <in> REL_OP

%type <in> program
%type <in> declarations
%type <in> identifier_list
%type <in> type
%type <in> compound_statement
%type <in> optional_statements
%type <in> statement_list
%type <in> statement
%type <in> expression
%type <in> MAR1
%type <in> MAR2
%type <in> simple_expression
%type <in> term
%type <in> factor

%%

program : MARD declarations compound_statement {
											printf("%s\n",id);
											printf("\n.code\n");
											printf("\n\nmain proc\n");
											printf("\nMOV AX,@data \nMOV ds,AX \nMOV es,AX \n");
										   printf($3.code);
										   printf("\nmain endp");
										   printf("\nend main");
										  }
	  ;

MARD: 									{	
											printf(".model small\n.stack 100H\n.data\n");
										}
										   ;
declarations : VAR identifier_list  MARI COLON type SEMICOLON {}
		;
MARI: 					{}
						;

identifier_list : ID   {printf("%s",$1.key);
						printf("  dw  0\n");}
						
				  | identifier_list COMMA ID   {printf("%s",$3.key);
												printf("  dw  0\n");}
		  ;

type : INTEGER {}
       ;

compound_statement : BEGIN1 optional_statements END {strcpy($$.code,$2.code);}
					 ;

optional_statements : {}
					  | statement_list{strcpy($$.code,$1.code);}
					  |EPSILON {} //remove this line
					  ;

statement_list : statement {strcpy($$.code,$1.code);}
	             |statement_list SEMICOLON statement {
														strcpy($$.code,$1.code);
														strcat($$.code,$3.code);
													
													}				     
       	         ;

statement : ID ASSIGNOP expression {
						string temp($3.code);
						temp+="\nmov ax,";
						temp+=$3.key;
						temp+="\nmov ";
						temp+=$1.key;
						temp+=",ax\n";			// mov ax,$3.key mov $1.key,ax
						strcpy($$.code,temp.c_str());
						//printf($$.code);
				  }
	    | compound_statement{
							strcpy($$.code,$1.code);
							}
	    | IF expression THEN statement  {
										strcpy($$.code,$2.code);
										newLabel();
										strcat($4.code,"\n");
										strcat($4.code,label);
										strcat($4.code,":\n");
										if(!strcmp($2.key,"<"))
										{	strcat($$.code,"JNL ");
											strcat($$.code,label);
										}else if(!strcmp($2.key,">"))
										{	strcat($$.code,"JNG ");
											strcat($$.code,label);
										}else if(!strcmp($2.key,"<>"))
										{strcat($$.code,"JE ");
											strcat($$.code,label);
										}else if(!strcmp($2.key,"<="))
										{strcat($$.code,"JG ");
											strcat($$.code,label);
										}else if(!strcmp($2.key,">="))
										{	strcat($$.code,"JL ");
											strcat($$.code,label);
										}else if(!strcmp($2.key,"=="))
										{	strcat($$.code,"JNE ");
											strcat($$.code,label);
										}
										strcat($$.code,"\n");
										strcat($$.code,$4.code);
										}
	    | IF expression THEN statement ELSE statement  {
														strcpy($$.code,$2.code);
														newLabel();
														strcat($6.code,label);
														strcat($6.code,":\n");
														strcat($4.code,"JMP ");
														strcat($4.code,label);
														strcat($4.code,"\n");
														newLabel();
														strcat($4.code,label);
														strcat($4.code,":\n");
														if(!strcmp($2.key,"<"))
														{	strcat($$.code,"JNL ");
															strcat($$.code,label);
														}else if(!strcmp($2.key,">"))
														{	strcat($$.code,"JNG ");
															strcat($$.code,label);
														}else if(!strcmp($2.key,"<>"))
														{	strcat($$.code,"JE ");
															strcat($$.code,label);
														}else if(!strcmp($2.key,"<="))
														{strcat($$.code,"JG ");
															strcat($$.code,label);
														}else if(!strcmp($2.key,">="))
														{	strcat($$.code,"JL ");
															strcat($$.code,label);
														}else if(!strcmp($2.key,"=="))
														{	strcat($$.code,"JNE ");
															strcat($$.code,label);
														}
														strcat($$.code,"\n");
														strcat($$.code,$4.code);
														strcat($$.code,$6.code);
													}
		| MAR1 WHILE expression DO statement MAR2  {}
																										
	    ;
		
MAR1: 	   {newLabel();
			strcpy($$.code,"\n");
			strcat($$.code,label);
			strcat($$.code,":\n");
			strcpy(lblwhile,label);}
			;
			
MAR2: 	   {strcpy($$.code,"JMP ");
			strcat($$.code,lblwhile);
			strcat($$.code,"\n");
			}
			
		    ;


expression : simple_expression{
					strcpy($$.code,$1.code);
					strcpy($$.key,$1.key);
					}
             |simple_expression REL_OP simple_expression {
														strcpy($$.code,$1.code);
														strcat($$.code,"\n");
														strcat($$.code,$3.code);
														strcat($$.code,"\n");
														strcpy($$.key,$2.key);
														strcat($$.code,"mov ax,");	        //mov ax,$1.key cmp ax,$3.key
														strcat($$.code,$1.key);
														strcat($$.code,"\ncmp ax,");
														strcat($$.code,$3.key);
														strcat($$.code,"\n");
														}											
	        ;

simple_expression : term{
						strcpy($$.code,$1.code);
						strcpy($$.key,$1.key);
						}
		    |sign term{}
		    |simple_expression ADDOP term{
										temp();
										strcpy($$.key,templabel);
										strcpy($$.code,$1.code);
										strcat($$.code,"\n");
										strcat($$.code,$3.code);
										strcat($$.code,"\n");
										strcat($$.code,"mov ax,");							// mov ax,$1.key add ax,$3.key mov $$.key,ax
										strcat($$.code,$1.key);
										strcat($$.code,"\nadd ax,");
										strcat($$.code,$3.key);
										strcat($$.code,"\nmov ");
										strcat($$.code,$$.key);
										strcat($$.code,",ax\n");
										}
		    ;
			
term : factor{
				strcpy($$.code,$1.code);
				strcpy($$.key,$1.key);
				}
       |term MULOP factor	{
							temp();
							strcpy($$.key,templabel);
							strcpy($$.code,$1.code);
							strcat($$.code,"\n");
							strcat($$.code,$3.code);
							strcat($$.code,"\n");
							strcat($$.code,"mov ax,");							// mov ax,$1.key imul $3.key mov $$.key,ax
							strcat($$.code,$1.key);
							strcat($$.code,"\nimul ");
							strcat($$.code,$3.key);
							strcat($$.code,"\nmov ");
							strcat($$.code,$$.key);
							strcat($$.code,",ax\n");
							 }
			  
       ;

factor : ID{
			strcpy($$.key,$1.key);
			
			}
	 |NUMBER{
	 strcpy($$.key,$1.key);
	 
	 }
	 |LPAREN expression RPAREN{
		strcpy($$.code,$2.code);
		strcpy($$.key,$2.key);
		
		}
	 ;

sign : SUBOP{}
      	
       ;


%%
void yyerror(const char *s)
 {fprintf(stderr,"%s\n",s);}

int main(){
freopen("in.txt","r",stdin);
freopen("outtt.txt","w",stdout);
yyparse();
}