%{

#include <stdio.h>

%}

Q0 j*\n
Q1 j*g((jggj|(g|jgj)(jj)*(g|jgj))(jj)*g)*\n
Q2 j*(g(g|jgj)|gjggj(jj|gjggj)*g(g|jgj))(jj|(g|jgj)(jj|gjggj)*g(g|jgj))*\n
Q3 j*(gjggj|g(g|jgj)(jj)*(g|jgj))(jj|gjggj|g(g|jgj)(jj)*(g|jgj))*\n
Q4 j*(gj|gg(jj)*(g|jgj)(jj|gg(jj)*(g|jgj))*gj)((ggj|gj(jj)*(g|jgj))(jj|gg(jj)*(g|jgj))*gj)*\n
Q5 j*(gjg|ggj|ggg(jj|ggg)*(gjg|ggj))(jj|(gj|jg)(jj|ggg)*(gjg|ggj))*\n 
Q6 j*(gjgg|g(g|jgj)(jj)*jg|g(g|jgj)(jj)*g(g(g|jgj)(jj)*g)*(j|gjgg|g(g|jgj)(jj)*jg))(j(g(g|jgj)(jj)*g)*(j|gjgg|g(g|jgj)(jj)*jg))*\n
Q7 j*(g(jj|jggg)|g(g|jgj)(jj)*jgg|(gjggj|g(g|jgj)(jj)*(g|jgj))(jj|gjggj|g(g|jgj)(jj)*(g|jgj))*(jg|g(jj|jggg)|g(g|jgj)(jj)*jgg))(g|j)*\n

%%

{Q0}	{ printf("1-%s",yytext); } 

{Q1}	{ printf("2-%s",yytext);} 

{Q2}	{ printf("2-%s",yytext);} 

{Q3}	{ printf("2-%s",yytext);} 

{Q4}	{ printf("1-%s",yytext);} 

{Q5}	{ printf("1-%s",yytext);} 

{Q6}	{ printf("1-%s",yytext);}

{Q7}	{ printf("1-%s",yytext);} 

%%


int main(){

	int valor = yylex();

	return valor;

}
