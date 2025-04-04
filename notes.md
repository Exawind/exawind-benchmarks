# Notes

Additional information regarding the benchmark cases is provided
below, including downloading the meshes, contributing to the ExaWind
Benchmarks project, and the authors of the benchmark cases.

## Downloading meshes

The meshes for many of the benchmark cases (Phase VI rotor, NACA 0021 airfoil, etc), are available from the github release page [https://github.com/Exawind/exawind-benchmarks/releases/tag/mesh_assets](https://github.com/Exawind/exawind-benchmarks/releases/tag/mesh_assets).  For convenience, we have included the download script `downloadmeshes.sh` to automatically download the meshes from the release page, uncompress them, and place them in the correct directories.  Use the script in the following manner:

```bash
$ git clone --recursive git@github.com:Exawind/exawind-benchmarks.git
$ cd exawind-benchmarks
$ ./util/downloadmeshes.sh
```

Note that meshes for only a particular subset of cases can be downloaded using the `--filter` option.  For instance, to download only the NACA 0021 airfoil cases, run the following:  

```
$ ./util/downloadmeshes.sh --filter naca0021
```

```{admonition} Note
Additional methods for distributing the mesh files are currently being investigated.  Please check back later regarding the use of DVC or other approaches for version-tracking of large binaries.
```

## Contributing to exawind-benchmarks

```{admonition} Note
For now, contributing to this repository is strictly an internal exercise for the DOE HFM project.	
Public contributions from the research community will be sought and incorporated starting in 2025.
```

## Credits

The following people contributed to the development of the ExaWind benchmark cases.

|   |   |
|---|---|
| Shreyas Bidadi       | National Renewable Energy Laboratories |
| Lawrence Cheung      | Sandia National Laboratories |
| Nate deVelder        | Sandia National Laboratories |
| Marc Henry de Frahan | National Renewable Energy Laboratories |
| Michael Kuhn         | National Renewable Energy Laboratories |
| Bumseok Lee          | National Renewable Energy Laboratories |
| Neil Matula          | Sandia National Laboratories |
| Prakash Mohan        | National Renewable Energy Laboratories |
| Gopal Yalla          | Sandia National Laboratories |
