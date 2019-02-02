#!/bin/bash
########################################################################
################################ INPUT #################################
########################################################################

#/****************************** SYSTEM ******************************/#

Nit=10       #Number of configurations over each point around the cluster
Ntheta=2                     #Number of steps around the cluster in theta
Nphi=4                         #Number of steps around the cluster in phi

rsep=0       #Maximun separation (A) between cluster surface and molecule


#/************************ VASP CONFIGURATION ************************/#

Project_Name=Test                       #A new directory will be created
Pseudo_Dir=                                   #Necessary for POTCAR file
pseudotype=                                               #Blank for PBE
Vect1=" 35.0000000   0.0000000    0.0000000  "  #Vectors for POSCAR file
Vect2=" 0.0000000   35.0000000    0.0000000  "
Vect3=" 0.0000000   0.0000000    35.0000000  "
Scale_factor=1

IncarFile=/home/Cluster-version/INCAR  #This file will be copied to each
                                                     #configuration file
KpointsFile=/home/Cluster-version/KPOINTS        #Will be copied to each
                                                     #configuration file










########################################################################
########################################################################
########################## COMIENZA ALGORITMO ##########################
########################################################################
########################################################################
Ns=$(head -1 cluster.xyz)
Nm=$(head -1 molecule.xyz)
Nat=$(($Ns+$Nm))                                 #Número total de átomos

dir=$(pwd)


head -$(($(head -1 molecule.xyz)+2)) molecule.xyz | tail -$(head -1 molecule.xyz) | sort | awk '{print $1 }' | uniq >> Elements
head -$(($(head -1 cluster.xyz)+2)) cluster.xyz | tail -$(head -1 cluster.xyz) | sort | awk '{print $1 }' | uniq >> Elements
Ntyp=$(cat Elements  | sort | uniq | grep .  | wc -l)
cat Elements>>aux5
rm Elements
cat aux5 | sort | uniq | grep . >> Elements
rm aux5
########## APLICA CG A LA MOLECULA #############

Nlmol=$(($Nm+2))
head -$Nlmol molecule.xyz >> molecula
tail -$Nm molecula >> coord
rm molecula
mv coord $dir/Programs
cd Programs
echo $Nm | ./CG >> coordCG.xyz
rm coord
cd ..
######## APLICA CG AL CLUSTER ##################
Nlclus=$(($Ns+2))
head -$Nlclus cluster.xyz >> cluster
tail -$Ns cluster >> coordclus
cat coordclus >>coordcluster #
#awk '{print $2 " " $3 " " $4 }' coordclus >> coordcluster
mv coordcluster $dir/Programs
rm coordclus
cd Programs
echo "$Ns" | ./Cgclus coordcluster >> coordCGclus
cat coordCGclus>>coordCGclus.xyz
#awk '{print "Au" " " $1 " " $2 " " $3 }' coordCGclus >> coordCGclus.xyz ##GENERALIZAR ESTA LINEA 
rm coordcluster
rm coordCGclus
####### HACE LA PARTICION DE LAS ROTACIONES #######
echo $Nit | ./N >> file
N=$(cat file)
rm file
M=$((2*$N))

cd  ..
mkdir $Project_Name
cd Programs
##### CALCULA  R del cluster y de la molecula ######
tail -$Ns coordCGclus.xyz >> coord
awk '{print $2 " " $3 " " $4 }' coord >> coord2
echo "$Ns" | ./rad  >> radios
 sort radios >> radord
Rclus=$(tail -1 radord)
rm coord
rm coord2
rm radios
rm radord
tail -$Nm coordCG.xyz >>  coord;  awk '{print $2 " " $3 " " $4 }' coord >> coord2
echo "$Nm" | ./rad  >> radios

 sort radios >> radord

Rmol=$(tail -1 radord)
rm coord
rm coord2
rm radios
rm radord
########## Calcula Rtotal ###############
echo "$rsep $Rclus $Rmol" | ./Rtotal >> Distanciatotal
#echo "$rsep $Rclus $Rmol"
Rtot=$(cat  Distanciatotal)
#echo "RTOTAL =  $Rtot #####################################################"
rm Distanciatotal
cd ..
########### TRASLACIONES DEL CLUSTER ###########
contador=0
cd $Project_Name
for((a=1;a<$(($Ntheta+1));a++))
do
for((b=0;b<$Nphi;b++))
do
cd ../Programs
echo "$Rtot $a $b $Ntheta $Nphi" | ./Sph_to_Car >> posicion

##### CALCULA LAS POSICIONES A COLOCAR LA MOLECULA COMO FUNCION DE (a,b) #####
CMolx=$(awk '{print $1 }' posicion)
CMoly=$(awk '{print $2 }' posicion)
CMolz=$(awk '{print $3 }' posicion)
rm posicion
cd ../$Project_Name
########## ROTACIONES DE LA MOLECULA ##########
for((j=0;j<$N;j++))
do
   for((k=0;k<$M;k++))
      do
       #mkdir $a$b$j$k #Crea un directorio para cada iteración
       mkdir Configuration$contador
       cd Configuration$contador #Cambia a ese  directorio y trabaja dentro de eL
       cp $dir/Programs/coordCG.xyz $dir/$Project_Name/Configuration$contador/coordCG.xyz #Trae los archivos 
       cp $dir/Programs/oprotacion $dir/$Project_Name/Configuration$contador/oprotacion #Trae el programa que 
       echo "$Nm $j $k $Nit $CMolx $CMoly $CMolz" | ./oprotacion #Ejecuta
       echo "$Nat">>  configuration.xyz
       echo " " >> configuration.xyz
tail -$Ns $dir/Programs/coordCGclus.xyz >>configuration.xyz
tail -$(($Nm+1)) coordRot.xyz >>configuration.xyz
       contador=$(($contador+1))

       #En este punto ya está hecha la configuración, se encuentra en formato
       #.xyz y es facilmente accesible en un visualizador. Ahora escriben
       #los inputs de VASP y pasa de .xyz a POSCAR

#############################################################################
############################# ESCRIBE EL INCAR ##############################
#############################################################################

cat $IncarFile >> INCAR

############################################################################
########################## ESCRIBE KPOINTS #################################
############################################################################

cat $KpointsFile >> KPOINTS

############################################################################
###################  LO SIGUIENTE ESCRIBE EL POSCAR ########################
############################################################################
echo "Iteracion $contador "  >>POSCAR

echo "$Scale_factor" >> POSCAR
echo "$Vect1">> POSCAR
echo "$Vect2">> POSCAR
echo "$Vect3">>POSCAR


for((i=1;i<$(($Ntyp+1));i++))
 do
 S=$(head -$i $dir/Elements | tail -1)
 echo -n "$S  " >> POSCAR
 done
echo " " >> POSCAR
for((i=1;i<$(($Ntyp+1));i++))
 do
 S=$(head -$i $dir/Elements | tail -1)
echo -n "$(grep "$S" configuration.xyz | wc -l )  ">>POSCAR
 done
echo "  " >> POSCAR

echo "Cartesian ">> POSCAR
for((i=1;i<$(($Ntyp+1));i++))
 do
 S=$(head -$i $dir/Elements | tail -1)
 grep  "$S" configuration.xyz | awk '{ print  $2, "  "  $3, "  "   $4 }' >> POSCAR
 done

##############################################################################
######  ESTE FOR ESTABA PENSADO PARA CONCATENAR LOS PSEUDOPOTENCIALES ########
##############################################################################

for((i=1;i<$(($Ntyp+1));i++))
 do
 S=$(head -$i $dir/Elements | tail -1)
cat $Pseudo_Dir/$S$pseudotype/POTCAR>>POTCAR #OJO ACA
 done

##############################################################################
########### ESTE FRAGMENTO ES UNA ALTERNATIVA A LO ANTERIOR ##################
##############################################################################
#concatenar a mano POTCAR
#colocarlo en el directorio de trabajo
#cp $dir/POTCAR   $dir/$i$j/POTCAR
#en cada iteracion copia    POTCAR

##############################################################################
################################ VASPRUN.sh ##################################
##############################################################################


##############################################################################
############ EXTRAE LAS COORDENADAS FINALES DEL CONTCAR ######################
##############################################################################


##############################################################################
############ EXTRAE LAS ENERGIAS DE CADA CONFIGURACION #######################
##############################################################################


cd ..
done
echo "Done"
done

done
done
cd ..
##############################################################################
############### ORDENA LAS ENERGIAS DE LOS SISTEMAS CISTEINA #################
##############################################################################

##############################################################################
##################### ELIMINA LOS FICHEROS RESIDUALES ########################
##############################################################################
#rm /Programs/coord
#m /Programs/coordCG.xyz
#rm /Programs/coordCGclus.xyz
cd $dir/Programs
rm coordCG.xyz
rm coordCGclus.xyz
cd ..
rm cluster
cd $Project_Name
for m in $(ls)
do
   if [ -d $m ]
   then
      cd $m
      #echo $m
      rm coordCG.xyz
      rm coordRot.xyz
      rm oprotacion
      cd ..
   fi
done
cd ..


#The next part of the code is responsible for running each configuration
#and analyzing the corresponding energies. I leave it commented
#with the intention that you can run the code without a supercomputer,
#so it will only generate the initial



cd $Project_Name
for m in $(ls)
do
   if [ -d $m ]
   then
      cd $m
      #mpirun -np $Ncore vasp_gam > salida.out #OJO ACA
#      echo $m
      cd ..
   fi
done
cd ..

### Analizador de energías ###
#cd $Nombre_del_proyecto
#for m in $(ls)
#do   if [ -d $m ]
#   then
#      cd $m
#      energia=$(tail -1 OSZICAR)
#      echo "$m $energia " >> ../Resumen_de_energias
#      cd ..
#   fi
#done
#cd ..
rm Elements
