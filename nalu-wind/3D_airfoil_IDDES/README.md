<!-- This file is automatically compiled into the website. Please copy linked files into .website_src/ paths to enable website rendering -->

# Three-dimensional (3D) flow past airfoils

These benchmark cases use IDDES for turbulence modeling, and they simulate flow past a NACA 0021 airfoil. Input files are provided for 4 angles of attack: 30, 45, 60 and 90 degrees.

The Nalu-Wind hash used was 4faf299. Every case was run on Kestrel for at least 100 iterations to confirm input-file compatibility and provide profiling information in the log file footer. The 30 degree case was run with different numbers of nodes to establish scaling behavior, and the 45 degree case was run for 8000 steps to output force and moment results.

These cases correspond to the following publication:
Bidadi, S.; Vijayakumar, G.; Sharma, A.; Sprague, M.A. Mesh and model requirements for capturing deep-stall aerodynamics in low-Mach-number flows. J. Turbul. 2023, 24, 393–418.


Results:

The above figure taken from the paper presents mesh resolution study results for the 
lift ($C_l$) and drag ($C_d$) profiles 
at $Re = 2.7\times10^5$. The number of spanwise points chosen are 41, 96 and 121, 
which correspond to 10, 24 and 30 cells per chord length.
In the chordwise and wall-normal directions, the number of points are fixed at 
240 and 257, respectively. The finer meshes provide good agreement with experiments for all 
angles of attack except at $17^\circ$. At this angle, the peak in $C_l$ is substantially
higher and is delayed compared to Swalwell et al. (2001) experimental results. 
In the deep stall regime, the percentage difference between the CFD and experimental results
is within or close to the $10\%$ threshold level on the finer spanwise grids.
The results show that, in the deep-stall regime, the IDDES model combined with atleast 24 cells per chord
accurately predicts the aerodynamic loads.

The benchmark cases consist of 240, 257 and 121 points in the chordwise, wall-normal and spanwise 
directions, respectively.
