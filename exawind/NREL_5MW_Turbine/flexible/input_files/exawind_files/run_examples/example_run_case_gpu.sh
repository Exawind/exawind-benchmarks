#!/bin/bash -l

#SBATCH -A CFD162
#SBATCH -o %x.o%j
#SBATCH -t 00:30:00
#SBATCH -q debug
#SBATCH -N 4
#SBATCH -J fsi-test

source $EXAWIND_MANAGER/start.sh
spack load exawind


module load PrgEnv-amd/8.5.0
module load amd/5.7.1
module load cray-mpich/8.1.27
export HIP_LAUNCH_BLOCKING=1
export FI_MR_CACHE_MONITOR=memhooks
export FI_CXI_RX_MATCH_MODE=software
export MPICH_SMP_SINGLE_COPY_MODE=NONE

srun -N 4 -n 32 --gpus-per-node=8 --gpu-bind=closest exawind --awind 16 --nwind 16 nrel5mw.yaml

mkdir run_$SLURM_JOBID
mv *.log run_$SLURM_JOBID
mv fsi-test.o$SLURM_JOBID run_$SLURM_JOBID
mv timings.dat run_$SLURM_JOBID/
mv forces*dat run_$SLURM_JOBID/
