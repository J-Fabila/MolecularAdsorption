# MolecularAdsorption. Cluster-version

The program generates a master directory, this contains a directory for every configuration, each one contains INCAR, POTCAR, KPOINTS  and POSCAR file, ready to run.

## How to use cluster-version

The  atomic positions will be readed  from molecule.xyz and cluster.xyz. Copy the coordinates to these files.
Open the adsorption.sh file with any text editor (e.g. Vi). Edit the input data. Each variable will be explained in  next section. *N.B.* As shell code the assignment of values to the variables must not contain empty spaces, *i.e.* "Nit=20" and not "Nit   =    20"

**Nit** Is the number of configurations over each point around the cluster

**Ntheta** Number of steps around the cluster in theta (usual spherical coordinates)

**Nphi** Number of steps around the cluster in phi (usual spherical coordinates)

**rsep** Maximum separation between the cluster  surface and molecule

**Project_Name** The nme of the master directory before mentioned

**Pseudo_Dir** The path where the VASP-pseudopotentials are located. The program use this path to generate to POTCAR file

**pseudotype** For example, if you want to use  the GW Gold VASP pseudopotential  (Au_GW) just write  pseudotype=_GW

**Scale_factor** For POSCAR file

**Vect1, Vect2, Vect3** Row vectors of matrix cell. Necessaries for POSCAR file.
```
For example:
Vect1=" 35.0000000   0.0000000    0.0000000  "  
Vect2=" 0.0000000   35.0000000    0.0000000  "
Vect3=" 0.0000000   0.0000000    35.0000000  "
 ```

**IncarFile** This is path of  the INCAR file you want to use for your calculations. Will be copied to every directory 

**KpointsFile** Idem

## How to compile

In Programs directory. Compile as follows:

```
gcc -o CG CG.c -lm
gcc -o cgclus cgclus.c -lm
gcc -o N N.c -lm
gcc -o Rtotal Rtotal.c -lm  
gcc -o Sph_to_Car Sph_to_Car.c -lm
gcc -o oprotacion oprotacion.c -lm
gcc -o rad rad.c -lm 
```
