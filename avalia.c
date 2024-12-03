#include <stdio.h>
#include "meuAlocador.h"

int main (long int argc, char** argv) {
  void *a,*b,*c,*d,*e;

  iniciaAlocador(); 
  puts("0) estado inicial");
  imprimeMapa();

  puts("1) Espero ver quatro segmentos ocupados");
  a=(void *) alocaMem(100);
  imprimeMapa();
  b=(void *) alocaMem(130);
  imprimeMapa();
  c=(void *) alocaMem(120);
  imprimeMapa();
  d=(void *) alocaMem(110);
  imprimeMapa();

  puts("2) Espero ver quatro segmentos alternando ocupados e livres");
  liberaMem(b);
  imprimeMapa(); 
  liberaMem(d);
  imprimeMapa(); 

  puts("3) Deduzam");
  b=(void *) alocaMem(50);
  imprimeMapa();
  d=(void *) alocaMem(90);
  imprimeMapa();
  e=(void *) alocaMem(40);
  imprimeMapa();
	
  puts("4) volta ao estado inicial");
  liberaMem(c);
  imprimeMapa(); 
  liberaMem(a);
  imprimeMapa();
  liberaMem(b);
  imprimeMapa();
  liberaMem(d);
  imprimeMapa();
  liberaMem(e);
  imprimeMapa();

  finalizaAlocador();
}
