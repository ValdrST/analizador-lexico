%{
#include <stdio.h>
#include "tokens.h"
%}

letra [a-z]|[A-Z]
espacio [\t \n]
esps {espacio}
digito [0-9]
letra_digito [a-zA-Z0-9_/()=$!'&|°\-+\{\}\[\].:,;\~\^]
cadena ("[letra_digito]*")
caracter ('\[letra_digito')
id [a-zA-Z_][_a-zA-Z0-9]*

%%
{digito}+ { return NUM; }
registro return REGISTRO;
fin return FIN;
inicio return INICIO;
entonces return ENTONCES;
si return SI;
hacer return HACER;
que return QUE;
escribir return ESCRIBIR;
leer return LEER;
devolver return DEVOLVER;
no return NO;
func return FUNC;
sin return SIN;
"<" return MENOR_QUE;
"=" return IGUAL;
oo return OO;
yy return YY;
falso return FALSO;
verdadero return VERDADERO;
"--" return MENOS_MENOS;
"<*" return COMENTARIO_ABRE;
"*>" return COMENTARIO_CIERRA;
ent return ENT;
real return REAL;
dreal return DREAL;
car return CAR;
sino return SINO;
mientras return MIENTRAS;
{caracter} return CARACTER;
{id} return ID;
\n return SALTO;
{cadena} return CADENA;
">" return MAYOR_QUE;
"(" return PARENTESIS_ABRE;
")" return PARENTESIS_CIERRA;
"[" return CORCHETE_ABRE;
"]" return CORCHETE_CIERRA;
"." return PUNTO;
"," return COMA;
":=" return ASIGNACION;
"+" return MAS;
"-" return MENOS;
"*" return MUL;
"/" return DIV;
"%" return MODULO;
{esps} {/* Ignorar los espacios en blanco */};
. {return LERROR;}
%%

void error(){
    printf("Error lexico en %s, linea %d",yytext,yylineno);
}

int main(int argc,char **argv){
    int token;
    char ctoken[3];
    yyin = fopen(argv[1],"r");
    if(yyin == 0 && argv[1] != NULL){
        printf("No se pudo abrir el archivo %s\n",argv[1]);
        return 1;
    }else if(yyin == NULL){
        printf("el archivo es nulo\n");
        return 1;
    }
    yyout = fopen(argv[2],"w");
    if(yyout == 0){
        printf("No se pudo crear el archivo %s\n",argv[2]);
        return 1;
    }
    
    int comentario_multilinea = 0;
    int comentario_linea = 0;
    while((token=yylex())!=0){
        sprintf(ctoken,"%d",token);
        if(!comentario_linea && !comentario_multilinea){
            fputs(ctoken,yyout);
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
    return 0;
}