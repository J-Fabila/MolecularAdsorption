#include<stdio.h>
#include<stdlib.h>
#include<math.h>
int i, Nm;
struct Atomo
{
char Simbolo[3];
float x[3];
};
//char Simbolo[100];
struct Atomo at[100];

float sumax, sumay, sumaz;
float cgx, cgy, cgz;


int main()
{
FILE *f = fopen("coord",  "r");

scanf(" %i \n", &Nm);
  for(i=0;i<Nm; i++)
    {
// Toma el archivo coord, guarda las coordenadas en la estructura at //
     fscanf(f, "%s %f %f %f \n",at[i].Simbolo, &at[i].x[0],  &at[i].x[1], &at[i].x[2]);
     sumax=sumax+at[i].x[0];
     sumay=sumay+at[i].x[1];
     sumaz=sumaz+at[i].x[2];

    }
//Simbolo[15]='\0';
// Calcula el  centro geometrico cg //
cgx=sumax/Nm;
cgy=sumay/Nm;
cgz=sumaz/Nm;
// Traslada la molécula al origen dado por el centro geometrico //
  for(i=0; i<Nm;i++)
     {
     at[i].x[0]=at[i].x[0]-cgx;
     at[i].x[1]=at[i].x[1]-cgy;
     at[i].x[2]=at[i].x[2]-cgz;
     printf("%s %lf   %lf   %lf\n", at[i].Simbolo, at[i].x[0], at[i].x[1],at[i].x[2]); 
    }
return 0;
}
