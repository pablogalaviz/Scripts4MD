#!/bin/bash
#PBS -r n
#PBS -V
#PBS -o stdout.txt
#PBS -e stderr.txt
#PBS -q gpuvolta
#PBS -P pt16
#PBS -l walltime=8:00:00
#PBS -l mem=50GB
#PBS -M galavizp@ansto.gov.au
#PBS -m abe
#PBS -l wd
#PBS -l ncpus=48
#PBS -l ngpus=4
#PBS -l jobfs=1GB
#PBS -l software=lammps
#PBS -l storage=scratch/pt16
#PBS -N pore_4nm_H2O

module load gromacs/2024.3-gpuvolta

export OMP_NUM_THREADS=12
export GMX_GPU_DD_COMMS=true
export GMX_GPU_PME_PP_COMMS=true
export GMX_FORCE_UPDATE_DEFAULT_GPU=true

export GMX_CMD="gmx"
export GMX_MPI_CMD="gmx"
export EXTRA_PARAMS=" -pin on -ntomp $OMP_NUM_THREADS -ntmpi 4 -nb gpu"

source ./job.sh
