#!/bin/bash

#SBATCH -J hybrid
#SBATCH -o %x.o%j
#SBATCH --account=CFD162
#SBATCH --time=24:00:00
#SBATCH --nodes=32
#SBATCH -S 0
#SBATCH --partition=extended

set -e
cmd() {
  echo "+ $@"
  eval "$@"
}

cmd "module unload PrgEnv-cray"
cmd "module load PrgEnv-gnu-amd/8.6.0"
cmd "module load amd-mixed/6.1.3"
cmd "module load cray-python"
# cmd "export FI_MR_CACHE_MONITOR=memhooks"
cmd "export FI_CXI_RX_MATCH_MODE=software"
cmd "export MPICH_SMP_SINGLE_COPY_MODE=NONE"
cmd "export MPICH_GPU_SUPPORT_ENABLED=0"
cmd "export EXAWIND_MANAGER=${HOME}/exawind/exawind-manager"
cmd "source ${EXAWIND_MANAGER}/start.sh && spack-start"
cmd "spack env activate -d ${EXAWIND_MANAGER}/environments/exawind-dev"
cmd "spack load exawind+amr_wind_gpu~nalu_wind_gpu"

AWIND_RANK_PER_NODE=8
NWIND_RANK_PER_NODE=56
NWIND_SOLVERS=4

cmd "srun -n 1 openfastcpp inp_T0.yaml > precursor_T0.log 2>&1"
cmd "srun -n 1 openfastcpp inp_T1.yaml > precursor_T1.log 2>&1"
cmd "srun -n 1 openfastcpp inp_T2.yaml > precursor_T2.log 2>&1"
cmd "srun -n 1 openfastcpp inp_T3.yaml > precursor_T3.log 2>&1"

STK_BALANCE_RANKS=$((${SLURM_JOB_NUM_NODES}*${NWIND_RANK_PER_NODE}/${NWIND_SOLVERS}))
STK_BALANCE_NODES=$((${STK_BALANCE_RANKS}/64))
MESH_FILE="../mesh/split_tower_and_blades.exo"
cmd "rm -f ${MESH_FILE}.*"
cmd "rm -f split_tower_and_blades.1_to_${STK_BALANCE_RANKS}.log"
cmd "srun -N${STK_BALANCE_NODES} -n${STK_BALANCE_RANKS} stk_balance.exe ${MESH_FILE} --decomp-method=parmetis"

cmd "python3 ${HOME}/exawind/source/exawind-cases/tools/reorder_file.py ${SLURM_JOB_NUM_NODES}"
cmd "mv exawind.reorder_file frontier_exawind.reorder_file"
AWIND_RANKS=$((${SLURM_JOB_NUM_NODES}*${AWIND_RANK_PER_NODE}))
NWIND_RANKS=$((${SLURM_JOB_NUM_NODES}*${NWIND_RANK_PER_NODE}))
TOTAL_RANKS=$((${SLURM_JOB_NUM_NODES}*(${AWIND_RANK_PER_NODE}+${NWIND_RANK_PER_NODE})))

cmd "export MPICH_RANK_REORDER_METHOD=3"
cmd "export MPICH_RANK_REORDER_FILE=frontier_exawind.reorder_file"
cmd "export HDF5_CHUNK_SIZE=131072"

cmd "srun -N${SLURM_JOB_NUM_NODES} -n${TOTAL_RANKS} --gpus-per-node=8 --gpu-bind=closest exawind --awind ${AWIND_RANKS} --nwind ${NWIND_RANKS} nrel5mw.yaml"
