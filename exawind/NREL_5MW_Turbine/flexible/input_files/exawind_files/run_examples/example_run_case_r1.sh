#!/bin/bash 

#SBATCH -A FY190020
#SBATCH -t 96:00:00
#SBATCH --qos=long
#SBATCH --reservation=flight-cldera

#SBATCH -o ws6.52_log_%j.out
#SBATCH -J ws6.52_iea15mw
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ndeveld@sandia.gov
#SBATCH -N 36

####SBATCH --wait

# load the modules with exawind executable/setup the run env
# MACHINE_NAME will get populated via aprepro
source /pscratch/ndeveld/hfm-2024-q3/iea15mw/power_curve/envs/flight_setup_env.sh

nodes=$SLURM_JOB_NUM_NODES
rpn=$RANKS_PER_NODE
ranks=$(( $rpn*$nodes ))

nalu_ranks=2688
amr_ranks=$(( $ranks-$nalu_ranks ))

#srun --exclusive -N 1 -n 1 openfastcpp inp-t1.yaml &
#srun --exclusive -N 1 -n 1 openfastcpp inp-t2.yaml &
#wait

srun -N $nodes -n $ranks exawind --nwind $nalu_ranks --awind $amr_ranks iea15mw-01-amrnalu-r1.yaml &> log

# isolate run artifacts to make it easier to automate restarts in the future
# if necessary
mkdir run_$SLURM_JOBID
mv *.log run_$SLURM_JOBID
mv *_log_* run_$SLURM_JOBID
mv timings.dat run_$SLURM_JOBID
mv forces*dat run_$SLURM_JOBID

chown $USER:wg-sierra-users .
chmod g+s .

