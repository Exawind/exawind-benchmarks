# Postprocessing AWAKEN benchmark results

**Contents**

- [OpenFAST turbine results](#openfast-turbine-results)

**Note**: In many of the python scripts and Jupyter notebooks provided, the path to the [AMR-Wind front end](https://github.com/Exawind/amr-wind-frontend) library must be provided.  If necessary, download the library and edit the lines in the python code which define `amrwindfedirs` to include any locations of that library.
```python
# Add any possible locations of amr-wind-frontend here
amrwindfedirs = ['/projects/wind_uq/lcheung/amrwind-frontend/',
                 '/ccs/proj/cfd162/lcheung/amrwind-frontend/']
import sys, os, shutil, io
for x in amrwindfedirs: sys.path.insert(1, x)
```

## OpenFAST turbine results

