#include<stdio.h>
#include<math.h>

#include<stdlib.h>
float r[200];
int i;
int N;
float x[200], y[200], z[200];
char Simbolo[2];
int main()
{
scanf("%d", &N);


FILE *f;
f=fopen("coord2", "r");
for(i=0; i<N; i++)
{
fscanf(f,"%f %f %f \n",&x[i], &y[i], &z[i]);
r[i]=(sqrt((x[i]*x[i])+(y[i]*y[i])+(z[i]*z[i])));
}
fclose(f);
for(i=0;i<N;i++)
{
printf("%f\n",r[i]);
}
return 0;
}
