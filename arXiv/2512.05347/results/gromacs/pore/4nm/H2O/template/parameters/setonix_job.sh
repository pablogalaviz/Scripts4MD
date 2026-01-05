#!/bin/sh
#SBATCH --job-name=pore_720H2O   # Job name
#SBATCH --output=stdout.txt # Name of stdout output file
#SBATCH --error=stderr.txt  # Name of stderr error file
#SBATCH --account=pawsey0916 # Project for billing
#SBATCH --partition=work       # Partition (queue) name
#SBATCH --nodes=1               # Total number of nodes
#SBATCH --ntasks-per-node=32     # 8 MPI ranks per node
#SBATCH --cpus-per-task=4
#SBATCH --time=24:00:00         # Run time (d-hh:mm:ss)
#SBATCH --exclusive
 
module load gromacs/2023-mixed

export OMP_NUM_THREADS=4
export OMP_PROC_BIND=spread
export OMP_PLACES=threads

export FI_CXI_DEFAULT_VNI=$(od -vAn -N4 -tu < /dev/urandom)

export GMX_CMD="gmx_mpi"
export GMX_MPI_CMD="srun -u -N $SLURM_JOB_NUM_NODES -n $SLURM_NTASKS -c $OMP_NUM_THREADS gmx_mpi"
export EXTRA_PARAMS=" -pin on -ntomp $OMP_NUM_THREADS"


# -----Executing command:
source ./job.sh