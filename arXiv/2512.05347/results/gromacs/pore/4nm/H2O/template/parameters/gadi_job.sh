#!/bin/bash
#PBS -r n
#PBS -V
#PBS -o stdout.txt
#PBS -e stderr.txt
#PBS -q normal
#PBS -P pt16
#PBS -l walltime=10:00:00
#PBS -l mem=50GB
#PBS -M galavizp@ansto.gov.au
#PBS -m abe
#PBS -l wd
#PBS -l ncpus=48
#PBS -l jobfs=1GB
#PBS -l software=lammps
#PBS -l storage=scratch/pt16
#PBS -N pore_4nm_H2O

module load gromacs/2024.1

export OMP_NUM_THREADS=4


export GMX_CMD="gmx_mpi"
export GMX_MPI_CMD="mpirun gmx_mpi"
export EXTRA_PARAMS=" -pin on -ntomp $OMP_NUM_THREADS"

source ./job.sh