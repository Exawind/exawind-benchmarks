#!/bin/bash

#SBATCH -J stk_balance
#SBATCH -o %x.o%j
#SBATCH --account=hfm
#SBATCH --reservation=exawind-movie
#SBATCH --time=1:00:00
#SBATCH --nodes=8
#SBATCH --gpus=32
#SBATCH --gpus-per-node=4
#SBATCH --exclusive
#SBATCH --mem=0

set -e
cmd() {
  echo "+ $@"
  eval "$@"
}

cmd "export EXAWIND_MANAGER=${HOME}/exawind/exawind-manager"
cmd "source ${EXAWIND_MANAGER}/start.sh && spack-start"
cmd "spack env activate -d ${EXAWIND_MANAGER}/environments/exawind-dev-cuda"
cmd "spack load exawind"
cmd "srun -N8 -n 960 stk_balance.exe ${HOME}/exawind/source/exawind-benchmarks/exawind/NREL_5MW_Turbine/flexible/mesh/split_tower_and_blades.exo --decomp-method=parmetis"
