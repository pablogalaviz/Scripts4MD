#!/bin/bash --login
#SBATCH --account=pawsey0916
#SBATCH --partition=work
#SBATCH --nodes=1               # Total number of nodes
#SBATCH --ntasks-per-node=32     # 8 MPI ranks per node
#SBATCH --cpus-per-task=4
#SBATCH --time=24:00:00         # Run time (d-hh:mm:ss)
#SBATCH --exclusive
#SBATCH --mem=230GB
#SBATCH --output=stdout.txt
#SBATCH --error=stderr.txt
#SBATCH --job-name=qe_SiO2_relax_r

export OMP_NUM_THREADS=4
export OMP_PROC_BIND=spread
export OMP_PLACES=threads

# ---
# Temporal workaround for avoiding Slingshot issues on shared nodes:
FI_CXI_DEFAULT_VNI=$(od -vAn -N4 -tu < /dev/urandom)
export FI_CXI_DEFAULT_VNI

module load quantum-espresso/7.2

# -----Executing command:
srun -u -N "$SLURM_JOB_NUM_NODES" -n "$SLURM_NTASKS" -c "$OMP_NUM_THREADS" -m block:block:block pw.x -in pw.in  -nk $OMP_NUM_THREADS > pw.out
#=====END====
