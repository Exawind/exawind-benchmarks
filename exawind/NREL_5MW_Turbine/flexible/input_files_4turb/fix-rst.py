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
    parser.add_argument(
        "-n", "--nremove", help="Number of steps to remove", type=int, default=1
    )
    args = parser.parse_args()
    oname = f"new-{args.fname}"
    pathlib.Path(oname).unlink(missing_ok=True)

    with Dataset(args.fname, "r", format="NETCDF3_CLASSIC") as src, Dataset(
        oname, "w", format="NETCDF3_CLASSIC"
    ) as dst:
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
            dst[name][:] = (
                src[name][: -args.nremove] if args.nremove != 0 else src[name][:]
            )
            print(
                f"Copying variable {name} with original shape {src[name].shape} to new shape {dst[name].shape}"
            )
            # copy variable attributes all at once via dictionary
            dst[name].setncatts(src[name].__dict__)


if __name__ == "__main__":
    main()
