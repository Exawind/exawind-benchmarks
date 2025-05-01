from netCDF4 import Dataset
import argparse
import numpy as np
import pathlib


def main():

    parser = argparse.ArgumentParser(
        description="Remove last time step from netcdf file"
    )
    parser.add_argument(
        "-f", "--fname", help="NetCDF file name", type=str, required=True
    )
    args = parser.parse_args()
    oname = f"new-{args.fname}"
    pathlib.Path(oname).unlink(missing_ok=True)

    nsteps_to_remove = 1
    with Dataset(args.fname, "r", format="NETCDF3_CLASSIC") as src, Dataset(oname, "w", format="NETCDF3_CLASSIC") as dst:
        # copy global attributes all at once via dictionary
        dst.setncatts(src.__dict__)
        # copy dimensions
        for name, dimension in src.dimensions.items():
            dst.createDimension(
                name, (len(dimension) if not dimension.isunlimited() else None)
            )
        # copy all file data
        for name, variable in src.variables.items():
            x = dst.createVariable(name, variable.datatype, variable.dimensions)
            dst[name][:] = src[name][:-nsteps_to_remove]
            # copy variable attributes all at once via dictionary
            dst[name].setncatts(src[name].__dict__)


if __name__ == "__main__":
    main()
