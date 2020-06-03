#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include<time.h>

int a,b, i, j, k, l, m,  n;
float epsilon, delta, min, max;

struct Atomo
{
char Simbolo[3];
float x[3];
};

struct Atomo atRot[100];
struct Atomo at[100];
struct Atomo atTras[100];
float cgx, cgy, cgz;
int N, M,  Nit, Ntheta,Nphi;
float s;
float CMolx, CMoly, CMolz;
float Rot[3][3];
float Rx[3][3];
float Rz[3][3];
float theta, phi;
int Nm;
int main()
{
scanf("%i %i %i %i %f %f %f", &Nm, &j, &k, &Nit, &CMolx, &CMoly, &CMolz);
N=floor(sqrt(Nit/2));
M=(2*N);
//epsilon y delta son el elemento aleatorio del algoritmo
max=(3.1415926535/(2*N));
min=-max;
epsilon=min+(float)rand()/((float)RAND_MAX / (max-min));
theta= (3.1415926535*j/N)+epsilon;
max=(3.1415926535/(2*M));
min=-max;
delta=min+(float)rand()/((float)RAND_MAX / ( max-min) );
phi=(2*3.1415926535*k/M)+delta;

//THETA=(3.1415926535*a/(Ntheta+1));
//PHI=(3.1415926535*b/Nphi);
FILE *f = fopen("coordCG.xyz", "r"); //Archivo de entrada
FILE *g = fopen("coordRot.xyz", "w"); //Archivo de salida
for(i=0;i<Nm;i++)
{
fscanf(f, "%s  %f  %f  %f\n", at[i].Simbolo, &at[i].x[0], &at[i].x[1], &at[i].x[2]);
}
Rot[0][0]=cos(phi);
Rot[0][1]=(-cos(theta)*sin(phi));
Rot[0][2]=sin(phi)*sin(theta);
Rot[1][0]=sin(phi);
Rot[1][1]=cos(theta)*cos(phi);
Rot[1][2]=(-sin(theta)*cos(phi));
Rot[2][0]=0;
Rot[2][1]=sin(theta);
Rot[2][2]=cos(theta);
for(i=0;i<Nm;i++)
{
for(l=0;l<3;l++)
    {
     s=0;
     for(m=0;m<3;m++)
        {
        s=s+(Rot[l][m]*(at[i].x[m]));
        }
     atRot[i].x[l]=s;
    }
}
for(i=0;i<Nm;i++)
{
 // Traslada las coordenadas rotadas sobre el clúster //
atTras[i].x[0]=atRot[i].x[0]+CMolx;
atTras[i].x[1]=atRot[i].x[1]+CMoly;
atTras[i].x[2]=atRot[i].x[2]+CMolz;

// Imprime las nuevas coordenadas en un archivo de texto //
fprintf(g, "%s   %f   %f   %f \n ", at[i].Simbolo, atTras[i].x[0], atTras[i].x[1], atTras[i].x[2]);


}
fclose(g);
return 0;
}
