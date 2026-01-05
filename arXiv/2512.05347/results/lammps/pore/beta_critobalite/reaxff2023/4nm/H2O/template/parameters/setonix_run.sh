#!/bin/sh
#SBATCH --job-name=SiO2_4nm_H2O_r   # Job name
#SBATCH --output=lmp.o%j # Name of stdout output file
#SBATCH --error=lmp.e%j  # Name of stderr error file
#SBATCH --account=pawsey0916 # Project for billing
#SBATCH --partition=work       # Partition (queue) name
#SBATCH --nodes=1               # SiO2 number of nodes
#SBATCH --ntasks-per-node=32     # 8 MPI ranks per node
#SBATCH --cpus-per-task=4
#SBATCH --time=24:00:00         # Run time (d-hh:mm:ss)
#SBATCH --exclusive
 
module load lammps/20230802.3

export OMP_NUM_THREADS=4
export OMP_PROC_BIND=spread
export OMP_PLACES=threads

export FI_CXI_DEFAULT_VNI=$(od -vAn -N4 -tu < /dev/urandom)

# -----Executing command:
srun -u -N $SLURM_JOB_NUM_NODES -n $SLURM_NTASKS -c $OMP_NUM_THREADS lmp -in in.lammps -nocite -log results/lammps.log
