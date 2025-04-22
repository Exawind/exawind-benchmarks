#!/bin/bash

#SBATCH -J stk_balance
#SBATCH -o %x.o%j
#SBATCH --account=CFD162
#SBATCH --time=0:30:00
#SBATCH --nodes=1
#SBATCH -q debug
#SBATCH -S 0

set -e
cmd() {
  echo "+ $@"
  eval "$@"
}

cmd "export EXAWIND_MANAGER=${HOME}/exawind/exawind-manager"
cmd "source ${EXAWIND_MANAGER}/start.sh && spack-start"
cmd "spack env activate -d ${EXAWIND_MANAGER}/environments/exawind-dev"
cmd "spack load exawind"
cmd "srun -N15 -n 960 stk_balance.exe ../mesh/split_tower_and_blades.exo --decomp-method=parmetis"
