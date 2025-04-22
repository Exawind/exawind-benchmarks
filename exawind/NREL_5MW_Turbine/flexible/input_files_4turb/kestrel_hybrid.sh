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
echo "Running with 124 ranks per node and 1 ranks per GPU on 32 nodes for a total of 3968 ranks and 128 total GPUs with 128 AMR-Wind ranks and 3840 Nalu-Wind ranks..."

cmd "export EXAWIND_MANAGER=${HOME}/exawind/exawind-manager"
cmd "source ${EXAWIND_MANAGER}/start.sh && spack-start"
cmd "spack env activate -d ${EXAWIND_MANAGER}/environments/exawind-dev-cuda"
cmd "spack load exawind"
cmd "export MPICH_OFI_SKIP_NIC_SYMMETRY_TEST=1"
cmd "export MPICH_GPU_SUPPORT_ENABLED=0"
cmd "export MPICH_RANK_REORDER_METHOD=3"
cmd "export MPICH_RANK_REORDER_FILE=exawind.reorder_file"
cmd "srun -N32 -n 3968 --gpus-per-node=4 --gpu-bind=closest exawind --awind 128 --nwind 3840 nrel5mw.yaml"
