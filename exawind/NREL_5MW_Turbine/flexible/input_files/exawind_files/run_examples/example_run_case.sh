#!/bin/bash 

#SBATCH -A FY240196
#SBATCH -t 96:00:00
#SBATCH --qos=long
#SBATCH --reservation=flight-cldera

#SBATCH -o nrel5mw_log_%j.out
#SBATCH -J nrel5mw
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ndeveld@sandia.gov
#SBATCH -N 64

####SBATCH --wait

# load the modules with exawind executable/setup the run env
# MACHINE_NAME will get populated via aprepro
source /pscratch/ndeveld/hfm-2025-q1/flight_setup_env.sh

nodes=$SLURM_JOB_NUM_NODES
rpn=112
ranks=$(( $rpn*$nodes ))

nalu_ranks=672
amr_ranks=$(( $ranks-$nalu_ranks ))



srun -N $nodes -n $ranks exawind --nwind $nalu_ranks --awind $amr_ranks nrel5mw.yaml &> log
#wait

#srun -N $nodes -n $ranks exawind --nwind $nalu_ranks --awind $amr_ranks iea15mw-01-amrnalu-r1.yaml &> log.r1

# isolate run artifacts to make it easier to automate restarts in the future
# if necessary
mkdir run_$SLURM_JOBID
mv *.log run_$SLURM_JOBID
mv *_log_* run_$SLURM_JOBID
mv timings.dat run_$SLURM_JOBID
mv forces*dat run_$SLURM_JOBID

chown $USER:wg-sierra-users .
chmod g+s .

