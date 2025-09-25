#!/bin/bash

#SBATCH -J hybrid
#SBATCH -o %x.o%j
#SBATCH --account=hfm
#SBATCH --reservation=exawind-movie
#SBATCH --time=48:00:00
#SBATCH --nodes=32
#SBATCH --gpus=128
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
cmd "spack load exawind+amr_wind_gpu~nalu_wind_gpu"
cmd "export MPICH_OFI_SKIP_NIC_SYMMETRY_TEST=1"
cmd "export MPICH_GPU_SUPPORT_ENABLED=0"

AWIND_RANK_PER_NODE=4
NWIND_RANK_PER_NODE=124
NWIND_SOLVERS=4

cmd "srun -n 1 openfastcpp inp_T0.yaml > precursor_T0.log 2>&1"
cmd "srun -n 1 openfastcpp inp_T1.yaml > precursor_T1.log 2>&1"
cmd "srun -n 1 openfastcpp inp_T2.yaml > precursor_T2.log 2>&1"
cmd "srun -n 1 openfastcpp inp_T3.yaml > precursor_T3.log 2>&1"

STK_BALANCE_RANKS=$((${SLURM_JOB_NUM_NODES}*${NWIND_RANK_PER_NODE}/${NWIND_SOLVERS}))
MESH_FILE="../mesh/split_tower_and_blades.exo"
cmd "rm -f ${MESH_FILE}.*"
cmd "rm -f split_tower_and_blades.1_to_${STK_BALANCE_RANKS}.log"
cmd "srun -N${SLURM_JOB_NUM_NODES} -n${STK_BALANCE_RANKS} stk_balance.exe ${MESH_FILE} --decomp-method=parmetis"

cmd "python3 ${HOME}/exawind/source/exawind-cases/tools/reorder_file.py ${SLURM_JOB_NUM_NODES}"
cmd "mv exawind.reorder_file kestrel_exawind.reorder_file"
AWIND_RANKS=$((${SLURM_JOB_NUM_NODES}*${AWIND_RANK_PER_NODE}))
NWIND_RANKS=$((${SLURM_JOB_NUM_NODES}*${NWIND_RANK_PER_NODE}))
TOTAL_RANKS=$((${SLURM_JOB_NUM_NODES}*(${AWIND_RANK_PER_NODE}+${NWIND_RANK_PER_NODE})))

cmd "export MPICH_RANK_REORDER_METHOD=3"
cmd "export MPICH_RANK_REORDER_FILE=kestrel_exawind.reorder_file"

# cmd "srun -N${SLURM_JOB_NUM_NODES} -n${TOTAL_RANKS} --gpus-per-node=8 --gpu-bind=closest exawind --awind ${AWIND_RANKS} --nwind ${NWIND_RANKS} nrel5mw.yaml"
