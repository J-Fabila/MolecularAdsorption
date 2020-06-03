#include<time.h>
#include<stdio.h>
#include<stdlib.h>
#include<math.h>

//0=x,  1=y, 2=z; 0=r,1=theta, 2=phi
float r, theta, phi;
float x,y,z;
float epsilon, delta, M, N;
int Ntheta, Nphi;
int a, b;
int main()
{
srand (time(NULL));
scanf("%f %i %i %i %i",&r,&a,&b, &Ntheta, &Nphi);
// epsilon y delta son el elemento aleatorio del algoritmo
N=(3.1415926535/(2*(Ntheta)));
M=-N;
epsilon=M+(float)rand()/((float)RAND_MAX / (N-M));
N=(3.1415926535/(Nphi));
M=0-N;
delta=M+(float)rand()/((float)RAND_MAX / ( N-M) );

theta=(3.1415926535*a/(Ntheta))+epsilon;
phi=(2*3.1415926535*b/Nphi)+delta;

x=(r*sin(theta)*cos(phi));
y=(r*sin(theta)*sin(phi));
z=(r*cos(theta));


printf("%f %f %f\n", x, y, z);
return 0;
}

