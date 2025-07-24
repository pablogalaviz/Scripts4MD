#!/bin/sh
#SBATCH --job-name=reaxff22Fe3O4_np_2nm   # Job name
#SBATCH --output=stdout.log # Name of stdout output file
#SBATCH --error=stderr.log  # Name of stderr error file
#SBATCH --account=pawsey0916 # project for billing
#SBATCH --partition=work       # Partition (queue) name
#SBATCH --nodes=1               # Total number of nodes
#SBATCH --ntasks-per-node=128     # 8 MPI ranks per node
#SBATCH --time=8:00:00         # Run time (d-hh:mm:ss)
#SBATCH --exclusive
 
module load lammps/20230802.3

export OMP_NUM_THREADS=1
export OMP_PROC_BIND=spread
export OMP_PLACES=threads

export FI_CXI_DEFAULT_VNI=$(od -vAn -N4 -tu < /dev/urandom)

# -----Executing command:
srun -u -N $SLURM_JOB_NUM_NODES -n $SLURM_NTASKS -c $OMP_NUM_THREADS lmp -in in.lammps -nocite -log results/lammps.log
