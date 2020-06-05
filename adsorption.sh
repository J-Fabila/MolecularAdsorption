#!/bin/bash
########################################################################
################################ INPUT #################################
########################################################################

#/****************************** SYSTEM ******************************/#

Nit=2      #Number of configurations over each point around the cluster
Ntheta=4                     #Number of steps around the cluster in theta
Nphi=16                         #Number of steps around the cluster in phi

rsep=0       #Maximun separation (A) between cluster surface and molecule

N_cores=32     #Número de cores  entre los que se paralelizará con mpirun
                                    #es decir: mpirun -np N_cores vasp5.6

queue=q_residual

#/************************ VASP CONFIGURATION ************************/#

Project_Name=TEST              #A new directory will be created

Pseudo_Dir=/home/lopb_g/jrff_a/tmpu/VASP/pseudos   #Necessary for POTCAR file

pseudotype=                                               #Blank for PBE
Vect1=" 25.0000000   0.0000000    0.0000000  "  #Vectors for POSCAR file
Vect2=" 0.0000000   25.0000000    0.0000000  "
Vect3=" 0.0000000   0.0000000    25.0000000  "
Scale_factor=1

IncarFile=/home/lopb_g/jrff_a/Cisteina/vcluster/MolecularAdsorption-Cluster-version/INCAR  #This file will be copied to each
                                                     #configuration file
KpointsFile=/home/lopb_g/jrff_a/Cisteina/vcluster/MolecularAdsorption-Cluster-version/KPOINTS        #Will be copied to each
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
contador=1
cd $Project_Name
for((a=1;a<$(($Ntheta));a++))
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
echo "Iteracion $(($contador-1)) "  >>POSCAR

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
echo -n "$(grep -w  "$S" configuration.xyz | wc -l )  ">>POSCAR
 done
echo "  " >> POSCAR

echo "Cartesian ">> POSCAR
for((i=1;i<$(($Ntyp+1));i++))
 do
 S=$(head -$i $dir/Elements | tail -1)
 grep  -w "$S" configuration.xyz | awk '{ print  $2, "  "  $3, "  "   $4 }' >> POSCAR
 done


#############################################################################
######## LO SIGUIENTE CENTRA LAS COORDENADAS DEL POSCAR EN LA CELDA #########
#############################################################################

x1=$(echo $Vect1 | awk '{print $1}')
y1=$(echo $Vect1 | awk '{print $2}')
z1=$(echo $Vect1 | awk '{print $3}')

mx1=$(echo "$x1/2" | bc)
my1=$(echo "$y1/2" | bc)
mz1=$(echo "$z1/2" | bc)

x2=$(echo $Vect2 | awk '{print $1}')
y2=$(echo $Vect2 | awk '{print $2}')
z2=$(echo $Vect2 | awk '{print $3}')

mx2=$(echo "$x2/2" | bc)
my2=$(echo "$y2/2" | bc)
mz2=$(echo "$z2/2" | bc)

x3=$(echo $Vect3 | awk '{print $1}')
y3=$(echo $Vect3 | awk '{print $2}')
z3=$(echo $Vect3 | awk '{print $3}')

mx3=$(echo "$x3/2" | bc)
my3=$(echo "$y3/2" | bc)
mz3=$(echo "$z3/2" | bc)

nlp=$(($(cat POSCAR | wc -l )-8))
tail -$nlp POSCAR >>coordsajustar
nl=$(cat coordsajustar | wc -l)

awk '{print $1 }' coordsajustar >> coordsx
awk '{print $2 }' coordsajustar >> coordsy
awk '{print $3 }' coordsajustar >> coordsz

#paste coordsx coordsy coordsz

for ((ajustar=1;ajustar<$(($nl+1));ajustar++))
do
echo "$(head -$ajustar coordsx | tail -1) +$mx1+$mx2+$mx3" | bc  >> Xajustada
echo "$(head -$ajustar coordsy | tail -1) +$my1+$my2+$my3" | bc  >> Yajustada
echo "$(head -$ajustar coordsz | tail -1) +$mz1+$mz2+$mz3" | bc  >> Zajustada
done

head -8 POSCAR >>aux
rm POSCAR
mv aux POSCAR
paste Xajustada Yajustada Zajustada >> POSCAR


rm Xajustada Yajustada Zajustada coordsajustar coordsx coordsy coordsz




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
rm Elements 2> /dev/null

cd $Project_Name
echo "
echo \"Configuration Convergence F E\"
N=\$(ls | grep \"Configuration\" | wc -l)
for ((i=0;i<\$((\$N+1));i++))
do
   cd Configuration$i
   c=\$(grep \"reached\" salida* | wc -l )
   echo -n  \"\$i\"
   if [ \$c -eq  1 ]
   then
      echo -n \"  T  \"
   else
      echo -n \"  F  \"
   fi
   E=\$(tail -1 OSZICAR | awk '{print \$5}'  )
   F=\$(tail -1 OSZICAR | awk '{print \$3}'  )
   echo \"\$F  \$E \"
   cd ..
done 2> /dev/null

" > energies.sh
chmod +x energies.sh

contador=1
for ((i=0;i< $(($Nit*$Ntheta*$Nphi));i=i+5))
do
echo "

#!/bin/bash
#BSUB -q $queue
#BSUB -oo output$contador
#BSUB -eo error$contador
#BSUB -n $N_cores
#BSUB -J Lote_N$contador
module load use.own
module load vasp/5.4.4

#BSUB -R \"span[ptile=32]\"
#BSUB -m \"g3_a g3_b\"

N=\$(ls | grep \"Configuration\" | wc -l)
for ((i=0;i<\$((\$N+1));i++))
do
   cd Configuration\$i
   if [ -f OSZICAR ]
   then
      cd ..
   else
      mpirun -np $N_cores vasp_gam > salida.out
      cd ..
   fi
done

" > queue_$contador.sh
chmod  +x queue_$contador.sh
#bsub < queue_$contador.sh 

contador=$(($contador+1))
done


cd ..
