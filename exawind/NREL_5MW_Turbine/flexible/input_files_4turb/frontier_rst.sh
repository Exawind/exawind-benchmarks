#!/bin/bash

#SBATCH -J hybrid
#SBATCH -o %x.o%j
#SBATCH --account=CFD162
#SBATCH --time=24:00:00
#SBATCH --nodes=32
#SBATCH -S 0
#SBATCH --partition=extended
#SBATCH -d afterany:3395835 # 00 -> 01

set -e
cmd() {
  echo "+ $@"
  eval "$@"
}

RST_FNAME="nrel5mw_1.yaml"

cmd "module unload PrgEnv-cray"
cmd "module load PrgEnv-gnu/8.6.0"
cmd "module load miniforge3/23.11.0-0"
source activate /ccs/proj/cfd162/lcheung/condaenv/frontier2
AW_FRONTEND="/ccs/home/marchdf/exawind/source/amr-wind-frontend"
CHKPITER=$(ls -1rt 5MW_Land_BD_DLL_WTurb_T0/5MW_Land_BD_DLL_WTurb.*.chkp | tail -n 1 | awk -F '.' '{print $2}')
cmd "python ${AW_FRONTEND}/utilities/restartExaWind.py nrel5mw.yaml --chkpiter ${CHKPITER} -o ${RST_FNAME} -v --additer 0"
cmd "module unload PrgEnv-gnu/8.6.0"
cmd "module unload miniforge3/23.11.0-0"

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
cmd "spack load exawind+amr_wind_gpu~nalu_wind_gpu"

AWIND_RANK_PER_NODE=8
NWIND_RANK_PER_NODE=56
NWIND_SOLVERS=4

AWIND_RANKS=$((${SLURM_JOB_NUM_NODES}*${AWIND_RANK_PER_NODE}))
NWIND_RANKS=$((${SLURM_JOB_NUM_NODES}*${NWIND_RANK_PER_NODE}))
TOTAL_RANKS=$((${SLURM_JOB_NUM_NODES}*(${AWIND_RANK_PER_NODE}+${NWIND_RANK_PER_NODE})))

cmd "export MPICH_RANK_REORDER_METHOD=3"
cmd "export MPICH_RANK_REORDER_FILE=frontier_exawind.reorder_file"

cmd "srun -N${SLURM_JOB_NUM_NODES} -n${TOTAL_RANKS} --gpus-per-node=8 --gpu-bind=closest exawind --awind ${AWIND_RANKS} --nwind ${NWIND_RANKS} ${RST_FNAME}"
