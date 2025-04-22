#!/bin/bash

#SBATCH -J precursor
#SBATCH -o %x.o%j
#SBATCH --account=hfm
#SBATCH --time=00:30:00
#SBATCH --nodes=1

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

cmd "srun -n 1 openfastcpp inp_T0.yaml > precursor_T0.log 2>&1"
cmd "srun -n 1 openfastcpp inp_T1.yaml > precursor_T1.log 2>&1"
cmd "srun -n 1 openfastcpp inp_T2.yaml > precursor_T2.log 2>&1"
cmd "srun -n 1 openfastcpp inp_T3.yaml > precursor_T3.log 2>&1"
