#!/bin/bash

#SBATCH -J stk_balance
#SBATCH -o %x.o%j
#SBATCH --account=CFD162
#SBATCH --time=0:30:00
#SBATCH --nodes=15
#SBATCH -q debug
#SBATCH -S 0

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
cmd "srun -N15 -n 960 stk_balance.exe ../mesh/split_tower_and_blades.exo --decomp-method=parmetis"
