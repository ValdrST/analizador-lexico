%{
/*  Programado el 02-10-2019 
    Autor: Romero Andrade Vicente
*/
#include <stdio.h>
#include <string.h>
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
// Esta funcion devuelve donde fue el error
void error(){
    printf("Error lexico en %s, linea %d",yytext,yylineno);
}

// Funcion principal
int main(int argc,char **argv){
    int token; //se define la variable para el token
    char ctoken[3];// se define una variable para imprimir token como cadena
    yyin = fopen(argv[1],"r"); // Abre el archivo de apertura por argumentos
    if(yyin == 0 && argv[1] != NULL){ // Si este no se pudo abrir o no existe sale del programa
        printf("No se pudo abrir el archivo %s\n",argv[1]);
        return 1;
    }else if(yyin == NULL){ // Si no se pasa argumento se sale del programa
        printf("el archivo es nulo\n");
        return 1;
    }
    yyout = fopen(argv[2],"w");
    if(yyout == 0 && argv[2] != NULL){
        printf("No se pudo crear el archivo %s\n",argv[2]);
        return 1;
    }else if(yyout == NULL){
        printf("el archivo de salida es nulo\n");
        return 1;
    }
    
    int comentario_multilinea = 0; // variable de inicio de comentario multilinea
    int comentario_linea = 0; // Variable de inicio de comentario monolinea
    while((token=yylex())!=0){ // Asigna yylex a token siempre que no sea fin de archivo
        sprintf(ctoken,"%d",token); // Convierte el token a cadena
        if(!comentario_linea && !comentario_multilinea){ // Si no esta en estado de comentario se procesan los tokens
            fprintf(yyout,"%s ",ctoken); // Si escribe el token en el archivo de salida
            printf("<%d-%s>\n",token,yytext); // Imprime el token y su valor
            switch(token){ // Procesa los estados de comentario
            case MENOS_MENOS:
                comentario_linea = 1;
                break;
            case COMENTARIO_ABRE:
                comentario_multilinea = 1;
                break;
            case COMENTARIO_CIERRA: // Si se cierra el comentario sin abrir este devuelve error
                error();
                break;
            default:
                break;
            }
        }else if(comentario_linea){ //si se esta en modo comentario linea se termina hasta el salto de linea
            if(token = SALTO)
                comentario_linea = 0;
        }else if(comentario_multilinea){ // Cierra el estado de comentario multinilinea hasta que se detecte el cierre
            if(token == COMENTARIO_CIERRA){
                fprintf(yyout,"%s ",ctoken);
                printf("<%d-%s>\n",token,yytext);
                comentario_multilinea = 0;
            }
        }
    }
    return 0;
}