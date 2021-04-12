#!/bin/bash -e
#SBATCH --job-name=psim5           # job name (shows up in the queue)
#SBATCH --account=nesi00119        # Project Account
#SBATCH --time=01:00:00            # Walltime (HH:MM:SS)
#SBATCH --mem-per-cpu=4000         # memory/cpu (in MB, set to half of what's actually required)
##SBATCH --partition=prepost        # 3 hours, 2 (36) cores,      15GB
#SBATCH --partition=large,bigmem          # 3 days,  1024 (8424) cores, 3GB
##SBATCH --partition=bigmem         # 7 days,  108 (108) cores,   15GB
#SBATCH --hint=nomultithread       # don't use hyperthreading
##SBATCH --ntasks=9                 # number of tasks (e.g. MPI)
#SBATCH --ntasks=8                 # number of tasks (e.g. MPI)
#SBATCH --switches=1@0:10:00       # run on one infiniband switch, wait for 10 minutes

echo $HOSTNAME
echo "task array id: $SLURM_ARRAY_TASK_ID"

ml SUNDIALS/5.5.0-gimkl-2020a
ml Boost/1.71.0-GCCcore-9.2.0
ml Eigen/3.3.7

# directory associated with job array
job_dir=$( head -n $SLURM_ARRAY_TASK_ID dirs.txt | tail -1 )
echo $job_dir

cd $job_dir
#srun --ntasks=9 psim5
srun --ntasks=8 psim_coupled
#rm psim_coupled

ml Python/3.8.2-gimkl-2020a
srun --ntasks=1 python "SCRIPT_DIR/summary_plot.py"
srun --ntasks=1 python "SCRIPT_DIR/summary_plot_averages.py"
