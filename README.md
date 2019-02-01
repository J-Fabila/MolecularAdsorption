# RANDOM SEARCH GLOBAL OPTIMIZATION C/BASH CODE

We implemented a random search global optimization C / Bash code – coupled to the DFT software VASP - in order to explore the configurational space (PES) of the cysteine molecule adsorbed on both Au9 and Au34 clusters, via random displacements. ­The code works as follows:

1)    For metal clusters and nanoparticles ( < 100 atoms ), the code generates a number of initial, random configurations starting from an initial configuration of an adsorbed cysteine molecule on both Au9 and Au34 clusters.

2)    The configurations undergone local geometry relaxations using the VASP (DFT) software using the PBE XC functional, including the Tkatchenko-Scheffler method (TS-vdW) with iterative Hirshfeld partitioning for dispersion corrections.


3)    A list of putative local minima - with is corresponding global minima - is generated. 

4)    In this work, only zwitterionic cysteine/Au systems are analyzed and considered for further classification.

![figure1](https://user-images.githubusercontent.com/46831682/52142111-6318fd80-261d-11e9-9cc9-6ce3e952d0e0.png)

Implemented in spherical coordinates, r variable modules the cysteine to Au cluster surface distance (e.g r=0 implies that the cysteine molecule is “touching” the Au cluster). In our code, the elevation (90°) and inclination (180°) angles are divided by Nφ and Nθ variables. This gives a (Nφ x Nθ) number of possible adsorption sites for the cysteine molecule around the Au cluster. 

Furthermore, for each molecular displacement the cysteine molecule is rotated around its geometric center. This is intended to randomly change the cysteine orientation with respect to the Au cluster, thus allowing to explore adsorption via all functional groups (i.e. thiol, carboxyl and amino) without any bias assumption. Thus, given an initial cysteine/Au configuration, the C/Bash program will search (Nφ x Nθ x N) unique adsorption sites.

 


