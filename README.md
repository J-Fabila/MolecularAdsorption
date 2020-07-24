# RANDOM SEARCH GLOBAL OPTIMIZATION C/BASH CODE

[Revisiting the conformational adsorption of L‐ and D‐cysteine on Au nanoparticles by Raman spectroscopy](https://doi.org/10.1002/jrs.5782).

We implemented a random search global optimization C / Bash code – coupled to the DFT software VASP - in order to explore the configurational space (PES) of the cysteine molecule adsorbed on both Au9 and Au34 clusters, via random displacements. ­The code works as follows:

1)    For metal clusters and nanoparticles ( < 100 atoms ), the code generates a number of initial, random configurations starting from an initial configuration of an adsorbed cysteine molecule on both Au9 and Au34 clusters.

2)    The configurations undergone local geometry relaxations using the VASP (DFT) software using the PBE XC functional, including the Tkatchenko-Scheffler method (TS-vdW) with iterative Hirshfeld partitioning for dispersion corrections.


3)    A list of putative local minima - with is corresponding global minima - is generated. 

4)    In this work, only zwitterionic cysteine/Au systems are analyzed and considered for further classification.

![figure1](https://user-images.githubusercontent.com/46831682/52142111-6318fd80-261d-11e9-9cc9-6ce3e952d0e0.png)

Implemented in spherical coordinates, r variable modules the cysteine to Au cluster surface distance (e.g r=0 implies that the cysteine molecule is “touching” the Au cluster). In our code, the elevation (90°) and inclination (180°) angles are divided by Nφ and Nθ variables. This gives a (Nφ x Nθ) number of possible adsorption sites for the cysteine molecule around the Au cluster. 

Furthermore, for each molecular displacement the cysteine molecule is rotated around its geometric center. This is intended to randomly change the cysteine orientation with respect to the Au cluster, thus allowing to explore adsorption via all functional groups (i.e. thiol, carboxyl and amino) without any bias assumption. Thus, given an initial cysteine/Au configuration, the C/Bash program will search (Nφ x Nθ x N) unique adsorption sites.


The program generates a master directory, this contains a directory for every configuration, each one contains INCAR, POTCAR, KPOINTS  and POSCAR file, ready to run.

## How to use cluster-version

The  atomic positions will be readed  from molecule.xyz and cluster.xyz. Copy the coordinates to these files.
Open the adsorption.sh file with any text editor (e.g. Vi). Edit the input data. Each variable will be explained in  next section. *N.B.* Bash does not recognize the empty spaces, so you must write "Nit=20" and not "Nit   =    20"

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
gcc -o Cgclus Cgclus.c -lm
gcc -o N N.c -lm
gcc -o Rtotal Rtotal.c -lm  
gcc -o Sph_to_Car Sph_to_Car.c -lm
gcc -o oprotacion oprotacion.c -lm
gcc -o rad rad.c -lm 
```



