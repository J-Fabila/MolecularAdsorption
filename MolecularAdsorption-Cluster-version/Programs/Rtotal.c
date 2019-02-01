#include<stdio.h>

float rsep,  Rclus, Rmol, Rtot;
int main()

/* echo "$rsep $Rclus $Rmol" | ./Programs/Rtotal >> Distanciatotal */{
scanf(" %f %f %f",&rsep, &Rclus,&Rmol);

Rtot=(rsep+Rclus+Rmol);
printf("%f", Rtot);
return 0;
  }
