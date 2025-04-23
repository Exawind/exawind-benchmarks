#!/bin/bash

#SBATCH -J precursor
#SBATCH -o %x.o%j
#SBATCH --account=CFD162
#SBATCH --time=0:30:00
#SBATCH --nodes=1

set -e
cmd() {
  echo "+ $@"
  eval "$@"
}

cmd "module unload PrgEnv-cray"
cmd "module load PrgEnv-gnu-amd/8.6.0"
cmd "module load amd-mixed/6.1.3"
cmd "export FI_MR_CACHE_MONITOR=memhooks"
cmd "export FI_CXI_RX_MATCH_MODE=software"
cmd "export MPICH_SMP_SINGLE_COPY_MODE=NONE"
cmd "export MPICH_GPU_SUPPORT_ENABLED=0"
cmd "export EXAWIND_MANAGER=${HOME}/exawind/exawind-manager"
cmd "source ${EXAWIND_MANAGER}/start.sh && spack-start"
cmd "spack env activate -d ${EXAWIND_MANAGER}/environments/exawind-dev"
cmd "spack load exawind"

cmd "srun -n 1 openfastcpp inp_T0.yaml > precursor_T0.log 2>&1"
cmd "srun -n 1 openfastcpp inp_T1.yaml > precursor_T1.log 2>&1"
cmd "srun -n 1 openfastcpp inp_T2.yaml > precursor_T2.log 2>&1"
cmd "srun -n 1 openfastcpp inp_T3.yaml > precursor_T3.log 2>&1"
