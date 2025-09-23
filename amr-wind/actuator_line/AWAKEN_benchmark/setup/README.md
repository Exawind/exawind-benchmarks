# Setting up the AWAKEN benchmark simulation in AMR-Wind

**Contents**

- [Prerequisites](#prerequisites)
- [Preparing the measurement data](#preparing-the-measurement-data)
- [Set up the ABL precursor run]()
- [Compare statistics from the ABL precursor]()
- [Set up the wind farm run]()

## Prerequisites

The measured data from the AWAKEN benchmark problem should be downloaded and unpacked before running the ABL simulation.  Specifically required are the A1 profiling and scanning lidar data, and the site B ASSIST temperature profiles avaiable at the pages: 

- https://awaken-benchmark.readthedocs.io/en/latest/phase1.html
- https://awaken-benchmark.readthedocs.io/en/latest/phase2.html

For later comparisons, the wind farm performance data can also be downloaded from
- https://awaken-benchmark.readthedocs.io/en/latest/phase3.html

From the downloaded zip files, extract these three netcdf files and put them in a separate directory (here called `Phase2_Data`):
```bash
Phase2_Data/A1_profiling_lidar_10min.nc
Phase2_Data/A1_scanning_lidar_10min.nc
Phase2_Data/B_ASSIST.nc
```

In addition, download the [AMR-Wind front end](https://github.com/Exawind/amr-wind-frontend) tool.

The AMR-Wind front end tool has useful utilities which can be used for setting up the OpenFAST turbine model and postprocessing results, and will be required in the set up steps below.  It is available on github and can be downloaded via

	```bash
	$ git clone --recursive git@github.com:Exawind/amr-wind-frontend.git AMRWINDFEDIR
	```

    where `AMRWINDFEDIR` is the location you'd like the tool to be
    located.  For the basic use of front end tool, the usual python 3
    libraries (numpy, scipy, pandas, etc.) are required.

## Preparing the measurement data

Once the netcdf files are ready, we can create the MMC profiles necessary to drive the ABL precursor.  Use the [MMCprofiles_Ph3_try1.ipynb](MMCprofiles_Ph3_try1.ipynb) notebook for this purpose.

```python
tstart  = np.datetime64('2023-08-24T03:00')
t_5AM  = np.datetime64('2023-08-24T05:00')
t_7AM  = np.datetime64('2023-08-24T07:00')
```

```python
# Open NetCDF files
ds_A1prof = xr.open_dataset('Phase2_Data/A1_profiling_lidar_10min.nc')
ds_A1scan = xr.open_dataset('Phase2_Data/A1_scanning_lidar_10min.nc')

# Open the NetCDF file
ds_temperature = xr.open_dataset('Phase2_Data/B_ASSIST.nc')
```

## Set up the ABL precursor run

Use the notebook [MMC_BM3_BigPrecursor.ipynb](MMC_BM3_BigPrecursor.ipynb).

## Compare statistics from the ABL precursor

Use the notebook [MMC_BM3_BigPrecursor_ABLStats.ipynb](MMC_BM3_BigPrecursor_ABLStats.ipynb).

## Set up the wind farm run

Use the notebook [Prod1_Phase3.ipynb](Prod1_Phase3.ipynb).
