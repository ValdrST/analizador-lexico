%{
#include <stdio.h>
#include "tokens.h"
%}

%% option noyywrap
%% option yylineno

letra [a-zA−Z]
espacio [\t \n }]
esps {espacio}
digito [0-9]
letra_digito [a-zA-Z0-9_/()=$!'&|°\-+\{\}\[\].:,;\~\^]
cadena (\"[letra_digito]*\")
caracter (\'[letra_digito\')
id [a-zA-Z_][a-zA-Z0-9_]*

%%
{digito} return NUM;
"registro" return REGISTRO;
"fin" return FIN;
"inicio" return INICIO;
{id} return ID;
"\n" return SALTO ;
"entonces" return ENTONCES ;
"si" return SI ;
"hacer" return HACER ;
"mientras"  que return MIENTRAS_QUE ;
"hacer" return HACER ;
"escribir" return ESCRIBIR ;
"leer" return LEER ;
"devolver" return DEVOLVER ;
"no" return NO ;
">" return MAYOR_QUE ;
"(" return PARENTESIS_ABRE ;
")" return PARENTESIS_CIERRA ;
"[" return CORCHETE_ABRE ;
"]" return CORCHETE_CIERRA ;
"." return PUNTO ;
"," return COMA ;
"func" return FUNC ;
"sin" return SIN ;
">" return MENOR_QUE ;
"=" return IGUAL ;
{cadena} return CADENA ;
":=" return ASIGNACION ;
"+" return MAS ;
"-" return MENOS ;
"*" return MUL ;
"/" return DIV ;
"%" return MODULO ;
{caracter} return CARACTER ;
"oo" return OO ;
"yy" return YY ;
"falso" return FALSO ;
"verdadero" return VERDADERO ;
"--" return MENOS_MENOS ;
"<*" return COMENTARIO_ABRE ;
"*>" return COMENTARIO_CIERRA;
"ent" return ENT;
"real" return REAL;
"dreal" return DREAL;
"car" return CAR;
"sin" return SIN;
"sino" return SINO;
"mientras" return MIENTRAS;
{esps} {/* Ignorar los espacios en blanco */}
. error();
%%

void error(){
    print("Error lexico en %s, linea %d",yytext,yylineno);
}

int main(){
    yyin = fopen(s,"r");
    yyout = fopen(o,"w");
    int comentario_multilinea = 0;
    int comentario_linea = 0;
    while((token=yylex())!=0){
        if(!comentario_linea && !comentario_multilinea){
            fputs(token,yyout);
            printf("<%d-%s>\n",token,yytext);
            switch(token){
            case MENOS_MENOS:
                comentario_linea = 1;
                break;
            case COMENTARIO_ABRE:
                comentario_multilinea = 1;
                break;
            default:
                break;
            }
        }else if(comentario_linea){
            comentario_linea = 0;
        }else if(comentario_multilinea){
            if(token != COMENTARIO_CIERRA)
                comentario_multilinea = 0;
        }
    }
}