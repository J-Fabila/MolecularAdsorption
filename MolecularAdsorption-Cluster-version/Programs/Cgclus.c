#include<stdio.h>
#include<stdlib.h>
#include<math.h>
int i;
struct Atomo
{
char Simbolo[3];
float x[3];
};

struct Atomo at[200];
int Natomos;
float sumax, sumay, sumaz;
float cgx, cgy, cgz;


int main(int argc, char *argv[])
{
FILE *f = fopen(argv[1],  "r");

scanf("%i\n", &Natomos);

  for(i=0;i<Natomos; i++)
    {
// Toma el archivo coord, guarda las coordenadas en la estructura at //
     fscanf(f, " %s %f %f %f \n", at[i].Simbolo, &at[i].x[0],  &at[i].x[1], &at[i].x[2]);
     sumax=sumax+at[i].x[0];
     sumay=sumay+at[i].x[1];
     sumaz=sumaz+at[i].x[2];

    }
//Simbolo[Natomos]='\0';
// Calcula el  centro geometrico cg //
cgx=sumax/Natomos;
cgy=sumay/Natomos;
cgz=sumaz/Natomos;

// Traslada la molécula al origen dado por el centro geometrico //
  for(i=0; i<Natomos;i++)  //OJO ACA: 14? cambio por Natmos
     {
     at[i].x[0]=at[i].x[0]-cgx;
     at[i].x[1]=at[i].x[1]-cgy;
     at[i].x[2]=at[i].x[2]-cgz;
     printf("%s %lf   %lf   %lf\n",at[i].Simbolo, at[i].x[0], at[i].x[1],at[i].x[2]); 
    }
return 0;
}

