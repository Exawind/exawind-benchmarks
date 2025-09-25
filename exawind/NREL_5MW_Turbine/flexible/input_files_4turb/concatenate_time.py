import os
import shutil
from netCDF4 import Dataset
import numpy as np
from glob import glob


def concat_exodus_time(files, output):
    print(f"Creating {output} from {len(files)} files")
    first = Dataset(files[0], "r")

    out = Dataset(output, "w", format="NETCDF4")

    # copy global attributes all at once via dictionary
    out.setncatts(first.__dict__)
    # Copy dimensions
    for name, dimension in first.dimensions.items():
        out.createDimension(
            name, (len(dimension) if not dimension.isunlimited() else None)
        )
    # Copy variables
    for vname, varin in first.variables.items():
        out_var = out.createVariable(vname, varin.datatype, varin.dimensions)
        out_var.setncatts({k: varin.getncattr(k) for k in varin.ncattrs()})
        if "time_step" not in varin.dimensions:
            out_var[:] = varin[:]
    first.close()

    # Concatenate
    t_offset = 0
    for f in files:
        print(f"Appending: {f}")
        with Dataset(f, "r") as ds:
            n_time = len(ds.dimensions["time_step"])

            out.variables["time_whole"][t_offset : t_offset + n_time] = ds.variables[
                "time_whole"
            ][:]
            for vname, varin in ds.variables.items():
                if "time_step" in varin.dimensions:
                    out_var = out.variables[vname]
                    out_var[t_offset : t_offset + n_time] = varin[:]

            t_offset += n_time

    out.close()


def main():
    for sideset in ["blades", "tower"]:
        timestep_files = {}

        for dir in sorted(glob(f"{sideset}*/")):
            for f in sorted(glob(os.path.join(dir, f"{sideset}_T*.exo"))):
                key = os.path.basename(f)
                timestep_files.setdefault(key, []).append(f)

        for name, files in timestep_files.items():
            output = f"{name}_all.exo"
            concat_exodus_time(files, output)


if __name__ == "__main__":
    main()
