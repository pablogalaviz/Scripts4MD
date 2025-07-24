#!/bin/sh
#SBATCH --job-name=reaxff22Fe3O4_np_2nm   # Job name
#SBATCH --output=lmp.o%j # Name of stdout output file
#SBATCH --error=lmp.e%j  # Name of stderr error file
#SBATCH --account=pawsey0916-gpu # project for billing
#SBATCH --partition=gpu       # Partition (queue) name
#SBATCH --nodes=1               # Total number of nodes
##SBATCH --ntasks-per-node=1     # 8 MPI ranks per node
#SBATCH --gpus-per-node=1       # Allocate one gpu per MPI rank
#SBATCH --time=8:00:00         # Run time (d-hh:mm:ss)
#SBATCH --exclusive
 
module load PrgEnv-gnu/8.3.3

module load lammps-amd-gfx90a/20230802.3

export OMP_PROC_BIND=spread
export OMP_PLACES=threads
#export MPICH_GPU_SUPPORT_ENABLED=1
 
srun -u --export=All -n 1 lmp -k on g 1 -sf kk -pk kokkos cuda/aware on neigh half  -in in.lammps -nocite -log results/lammps.log
