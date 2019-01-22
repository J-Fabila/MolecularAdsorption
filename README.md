# MolecularAdsorption
This is a C-Bash code to generate initial configurations for the study of adsorption of molecules in metallic clusters
There are available two versions: for clusters and for substrates, the first one is recommended when the metallic cluster studied is small (less than 100 atoms) and it is aproximatly spheric, if it is too large, a better aproximation is to trate it like a surface, for that case exists  the substrate version, that works similarly than the other but adapted to a plane surface.
# //////////////////////////////////////////////////////////////////////

El programa de optimización consiste en la generación de muchas configuraciones iniciales que serán relajadas con VASP, hecho esto se seleccionan las de menor energía. Para ello se coloca la molécula de cisteína en diferentes posiciones respecto a la superficie del clúster.

El programa se encuentra disponible en GitHub #referencia#

El clúster es aproximadamente esférico, por tanto en una buena aproximación podemos generar un mesh esférico que cubra la superficie del clúster, cada punto del mesh será un punto (sitio) de adsorcion a analizar. la variable “r” del input modula la distancia (A) entre la cisteína y la superficie del cluster, r=0 implica que la molecula "toca" a la nanoparticula. Además el usuario debe ingresar al input los números Nphi y Ntheta. En coordenadas esféricas los 90° de la variable angular theta se dividen por Ntheta y los 180° de phi se dividen por Nphi dando un total de NphiXNtheta sitios de adsorción, encada uno de ellos la molécula será rotada alrededor de su propio centro geométrico, cambiando con cada rotación la orientación de la molécula respecto al clúster garantizando así que en cada punto se explore la adsorpcion de la molecula a través de todos sus grupos funcionales y posibles combinaciones de ellos, restringido, desde luego por la geometría de la misma molécula


El programa automaticamente genera un mesh uniformemente espaciado de tal manera que el número de rotaciones de la molécula sea N, dando así finalmente NthetaXNphiXN configuraciones iniciales distintas.


El usuario ingresa la variable (Proyect_Name), el programa genera un directorio llamado ProyectName que contendrá todas las configuraciones y archivos neccesarios para correr VASP.
Las configuraciones se generan a través de algoritmos iterativos, así que por simplicidad cada configuración se guarda en un directorio que lleva por título "ConfigurationX" con X el número que le corresponde dentro del algoritmo.


Las rotaciones y traslaciones de la molécula se realizan con programas escritos en C y contenidos en la carpeta Programs/. Mientras el manejo anteriormente descrito dedirectorios, archivos y programas de C se realiza a través de Shell Scripting (Bash).




