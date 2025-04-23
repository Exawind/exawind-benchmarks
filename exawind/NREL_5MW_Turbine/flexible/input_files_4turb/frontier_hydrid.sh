#!/bin/bash

#SBATCH -J stk_balance
#SBATCH -o %x.o%j
#SBATCH --account=CFD162
#SBATCH --time=48:00:00
#SBATCH --nodes=15
#SBATCH -S 0

#SBATCH -q debug
#SBATCH --time=00:30:00

set -e
cmd() {
  echo "+ $@"
  eval "$@"
}

cmd "module unload PrgEnv-cray"
cmd "module load PrgEnv-gnu-amd/8.6.0"
cmd "module load amd-mixed/6.1.3"
cmd "module load cray-python"
cmd "export FI_MR_CACHE_MONITOR=memhooks"
cmd "export FI_CXI_RX_MATCH_MODE=software"
cmd "export MPICH_SMP_SINGLE_COPY_MODE=NONE"
cmd "export MPICH_GPU_SUPPORT_ENABLED=0"
cmd "export EXAWIND_MANAGER=${HOME}/exawind/exawind-manager"
cmd "source ${EXAWIND_MANAGER}/start.sh && spack-start"
cmd "spack env activate -d ${EXAWIND_MANAGER}/environments/exawind-dev"
cmd "spack load exawind"

cmd "python3 ${HOME}/exawind/source/exawind-cases/tools/reorder_file.py ${SLURM_JOB_NUM_NODES}"
cmd "mv exawind.reorder_file frontier_exawind.reorder_file"
AWIND_RANK_PER_NODE=8
NWIND_RANK_PER_NODE=48
AWIND_RANKS=$((${SLURM_JOB_NUM_NODES}*${AWIND_RANK_PER_NODE}))
NWIND_RANKS=$((${SLURM_JOB_NUM_NODES}*${NWIND_RANK_PER_NODE}))
TOTAL_RANKS=$((${SLURM_JOB_NUM_NODES}*(${AWIND_RANK_PER_NODE}+${NWIND_RANK_PER_NODE})))

cmd "export MPICH_RANK_REORDER_METHOD=3"
cmd "export MPICH_RANK_REORDER_FILE=frontier_exawind.reorder_file"

cmd "srun -N${SLURM_JOB_NUM_NODES} -n${TOTAL_RANKS} --gpus-per-node=8 --gpu-bind=closest exawind --awind ${AWIND_RANKS} --nwind ${NWIND_RANKS} nrel5mw.yaml"
