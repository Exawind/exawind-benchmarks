# AMR-Wind code performance

## Overview

The relevant code versions are

- AMR-Wind version: [32811b18af31e7b54f7e5cb23c6ead424f21f1f0](https://github.com/Exawind/amr-wind/commit/32811b18af31e7b54f7e5cb23c6ead424f21f1f0)

The job was run on the NREL's [Kestrel](https://nrel.github.io/HPC/Documentation/Systems/) HPC cluster, on CPU nodes, using the following resources:

| Parameter       | Value |
|---              |---  |
| Number of nodes | 20   |
| Number of CPUs  | 2080 |
| Wall-time       | 144 hours|
| CPU-hours       | 299520     |

The overall simulation parameters

| Parameter              | Value |
|---                     |---    |
| Total simulation time  | 125000.0 sec |
| Simulation timestep    | 0.5 sec |
| Total mesh size        | 48,234,496 |
| Num mesh elements/rank | 23,190 |



Average time spent every iteration in the following categories:
|Category| Time [s]|
|---            | --- |
|Pre-processing | 0.0041|
|Solve          | 2.23|
|Post-processing| 0.024|
|**Total**      | 2.257 |

## Log file
**Header**

```
==============================================================================
                AMR-Wind (https://github.com/exawind/amr-wind)

  AMR-Wind version :: v3.1.5-11-g32811b18
  AMR-Wind Git SHA :: 32811b18af31e7b54f7e5cb23c6ead424f21f1f0
  AMReX version    :: 24.09-45-g6d9c25b989f1

  Exec. time       :: Thu Oct 24 18:32:32 2024
  Build time       :: Oct 14 2024 08:26:23
  C++ compiler     :: IntelLLVM 2023.2.0

  MPI              :: ON    (Num. ranks = 2080)
  GPU              :: OFF
  OpenMP           :: OFF

  Enabled third-party libraries:
    NetCDF    4.9.2
    HYPRE     2.31.0

           This software is released under the BSD 3-clause license.
 See https://github.com/Exawind/amr-wind/blob/development/LICENSE for details.
------------------------------------------------------------------------------
```
