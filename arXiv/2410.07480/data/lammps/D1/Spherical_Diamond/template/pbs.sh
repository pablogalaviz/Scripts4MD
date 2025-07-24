#!/bin/sh
#PBS -r n
#PBS -V
#PBS -o scheduler-stdout.txt
#PBS -e scheduler-stderr.txt
#PBS -l mem=100GB
#PBS -M your@email.com
#PBS -m abe
#PBS -l wd
#PBS -l ncpus=64
#PBS -N ND_300K

export OMP_NUM_THREADS=4

module load lammps/7Feb2024

mpirun -np $(($NN/$OMP_NUM_THREADS)) lmp -sf omp -pk omp $OMP_NUM_THREADS -in input.lmp -nocite -log results/lammps.log
