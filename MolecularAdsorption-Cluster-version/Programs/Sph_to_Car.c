#include<stdio.h>
#include<stdlib.h>
#include<math.h>

//0=x,  1=y, 2=z; 0=r,1=theta, 2=phi
float r, theta, phi;
float x,y,z;
int Ntheta, Nphi;
int a, b;
int main()
{

scanf("%f %i %i %i %i",&r,&a,&b, &Ntheta, &Nphi);
theta=(3.1415926535*a/(Ntheta+1));
phi=(3.1415926535*b/Nphi);

x=(r*sin(theta)*cos(phi));
y=(r*sin(theta)*sin(phi));
z=(r*cos(theta));


printf("%f %f %f\n", x, y, z);
return 0;
}
