 //Autores: Julen Salceda NIP:957049 ; Daniel del Prado NIP: 958028
%{
#include <stdlib.h>
#include <stdbool.h>


int lBloquesC = 0;
int lAcciones = 0;
int lCodigo = 0;
int reglas = 0;
int llaveCondicion = 0;

bool BseccionDeclaraciones = true;
bool enBloqueCodigo = false;

bool enSeccionReglas = false;
bool enBloqueAccion = false;

bool seccionCodigo = false;
%}
/* CONDICIONES DE ARRANQUE */

%x seccionDeclaraciones
%x bloqueCodigo 

%x seccionReglas
%x bloqueAccion

%x bloqueC

%x unComentario
%x muchosComentarios
%x cadenaReglas
%x cadenaAccion
%x cadenaCodigo

%% 
.	//Regla que ignora todo los carácteres sueltos
\n	//Los saltos de linea no me interesan
"//"	{BEGIN(unComentario);}
"/*"	{BEGIN(muchosComentarios);}
"%{"	{enBloqueCodigo = true;
	BseccionDeclaraciones = false; 
	BEGIN(bloqueCodigo);
	}

<seccionDeclaraciones>.
<seccionDeclaraciones>\n
<seccionDeclaraciones>"%{"	{enBloqueCodigo = true;
				BseccionDeclaraciones = false;	
				BEGIN(bloqueCodigo);}
<seccionDeclaraciones>"//"	{BEGIN(unComentario);}
<seccionDeclaraciones>"/*"	{BEGIN(muchosComentarios);}
<seccionDeclaraciones>"%%"	{BseccionDeclaraciones = false;
				enSeccionReglas = true;	
				BEGIN(seccionReglas);}



<bloqueCodigo>\"	{BEGIN(cadenaCodigo); }
<bloqueCodigo>\n	{lBloquesC++; }
<bloqueCodigo>"//"	{BEGIN(unComentario); }
<bloqueCodigo>"/*"	{BEGIN(muchosComentarios); }
<bloqueCodigo>"%}"	{BseccionDeclaraciones = true;
			enBloqueCodigo = false;
			BEGIN(seccionDeclaraciones);
			}
<bloqueCodigo>.	//Regla de tragar todo. Está al final porque coge las más grandes por orden.
		
<seccionReglas>\"	{BEGIN(cadenaReglas);}
	
<seccionReglas>[ \t]+\{	{enSeccionReglas = false; enBloqueAccion = true; BEGIN(bloqueAccion);}  //Uno o más tabuladores y el caracter de abrir llave
<seccionReglas>"//"	{BEGIN(unComentario);}
<seccionReglas>"/*"	{BEGIN(muchosComentarios);}
<seccionReglas>"%%"	{enSeccionReglas = false; seccionCodigo = true; BEGIN(bloqueC);}

<seccionReglas>.	//Comer todo lo demás. Resulta que esto no consume el \n
<seccionReglas>\n	//Luego necesito consumirlo yo

<bloqueAccion>\n	{lAcciones++;}
<bloqueAccion>"}"	{if (llaveCondicion == 0){
				lAcciones++; 
				enBloqueAccion = false; 
				enSeccionReglas = true; 
				BEGIN(seccionReglas); 
				reglas++; 
				
			} else {
				llaveCondicion --;
			}
			}
<bloqueAccion>"//"	BEGIN(unComentario);
<bloqueAccion>"/*"	BEGIN(muchosComentarios);
<bloqueAccion>\"	BEGIN(cadenaAccion);
<bloqueAccion>.		//Comer lo innecesario
<bloqueAccion>if[^{]+\{	llaveCondicion++;


<bloqueC>\n	lCodigo++;
<bloqueC>.	//Comer lo innecesario

<unComentario>. 	/* Traga todo lo que no sea un end line*/
<unComentario>\n	{  if (enBloqueCodigo){
				lBloquesC++;
				BEGIN(bloqueCodigo);
				}
			else if (enBloqueAccion){
				lAcciones++;
				BEGIN(bloqueAccion);
				}
			else if (seccionCodigo){
				lCodigo++;
				BEGIN(bloqueC);
				}
			else if (BseccionDeclaraciones){
				BEGIN (seccionDeclaraciones);
				}
			else if (seccionReglas){
				BEGIN (seccionReglas);
				}
			}
				

<muchosComentarios>"*/"	{  if (enBloqueCodigo){
				BEGIN(bloqueCodigo);
				}
			else if (enBloqueAccion){
				BEGIN(bloqueAccion);
				}
			else if (seccionCodigo){
				BEGIN(bloqueC);
				}
			else if (BseccionDeclaraciones){
				BEGIN (seccionDeclaraciones);
				}
			else if (seccionReglas){
				BEGIN (seccionReglas);
				}
			}
<muchosComentarios>\n	{if (enBloqueCodigo){
				lBloquesC++;
				}
			else if (enBloqueAccion){
				lAcciones++;	
				}
			else if(seccionCodigo){
				lCodigo++; 
				}
			}
<muchosComentarios>.	//Consumir lo que no sea salto de linea ni otra regla

<cadenaReglas>\"	{BEGIN(seccionReglas);}
<cadenaReglas>.	

<cadenaAccion>\"	{BEGIN(bloqueAccion);}
<cadenaAccion>\n	lAcciones++; ;
<cadenaAccion>.


<cadenaCodigo>\"	{BEGIN(bloqueCodigo);}
<cadenaCodigo>\n	lCodigo++; 
<cadenaCodigo>.	


%%
int main() {
	yylex();
	printf("Salida\n\n");
	printf("C1:%d\n", lBloquesC);
	printf("C2:%d\n",lAcciones);
	printf("C3:%d\n",lCodigo);
	printf("R:%d\n",reglas);
	}
	
