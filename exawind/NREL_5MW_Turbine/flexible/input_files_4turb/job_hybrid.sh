#!/bin/bash

#SBATCH -J precursor
#SBATCH -o %x.o%j
#SBATCH --account=hfm
#SBATCH --time=48:00:00
#SBATCH --nodes=32
#SBATCH --reservation=exawind-movie

set -e
cmd() {
  echo "+ $@"
  eval "$@"
}

cmd "export EXAWIND_MANAGER=${HOME}/exawind/exawind-manager"
cmd "source ${EXAWIND_MANAGER}/start.sh && spack-start"
cmd "spack env activate -d ${EXAWIND_MANAGER}/environments/exawind-dev-cuda"
cmd "spack load exawind"
cmd "export MPICH_OFI_SKIP_NIC_SYMMETRY_TEST=1"
cmd "export MPICH_GPU_SUPPORT_ENABLED=0"

cmd "srun -n 2432 exawind --awind 128 --nwind 2304 nrel5mw.yaml > nrel5mw.log 2>&1"
