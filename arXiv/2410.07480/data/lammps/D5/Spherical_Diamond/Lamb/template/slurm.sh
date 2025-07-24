#!/bin/sh
#SBATCH --job-name=ND_300K   # Job name
#SBATCH --output=lmp.o%j # Name of stdout output file
#SBATCH --error=lmp.e%j  # Name of stderr error file
#SBATCH --partition=queue_name       # Partition (queue) name
#SBATCH --nodes=1               # Total number of nodes
#SBATCH --ntasks-per-node=32     # 8 MPI ranks per node
#SBATCH --cpus-per-task=4
#SBATCH --time=24:00:00         # Run time (d-hh:mm:ss)
#SBATCH --exclusive

module load lammps

export OMP_NUM_THREADS=4
export OMP_PROC_BIND=spread
export OMP_PLACES=threads

# -----Executing command:
srun -u -N $SLURM_JOB_NUM_NODES -n $SLURM_NTASKS -c $OMP_NUM_THREADS lmp -sf omp -pk omp $OMP_NUM_THREADS -in input.lmp  -nocite -log results/lammps.log
