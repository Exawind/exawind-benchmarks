# Postprocessing AWAKEN benchmark results

**Contents**

- [Plot instantaneous hub-height planes](#plot-instantaneous-hub-height-planes)
- [OpenFAST turbine results](#openfast-turbine-results)
- [Averaged lidar results](#averaged-lidar-results)

**Note**: In many of the python scripts and Jupyter notebooks provided, the path to the [AMR-Wind front end](https://github.com/Exawind/amr-wind-frontend) library must be provided.  If necessary, download the library and edit the lines in the python code which define `amrwindfedirs` to include any locations of that library.
```python
# Add any possible locations of amr-wind-frontend here
amrwindfedirs = ['/projects/wind_uq/lcheung/amrwind-frontend/',
                 '/ccs/proj/cfd162/lcheung/amrwind-frontend/']
import sys, os, shutil, io
for x in amrwindfedirs: sys.path.insert(1, x)
```

## Plot instantaneous hub-height planes

Use [Plot_Hubheight_Instantaneous.ipynb](Plot_Hubheight_Instantaneous.ipynb)

![](../results/images/KP_z090hh.gif)

## OpenFAST turbine results

Use [Extract_OF_Results.ipynb](Extract_OF_Results.ipynb)

## Averaged lidar results

Use [AVG_Lidar.ipynb](AVG_Lidar.ipynb)

