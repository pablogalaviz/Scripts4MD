#!/bin/bash
#PBS -r n
#PBS -V
#PBS -o _scheduler-stdout.txt
#PBS -e _scheduler-stderr.txt
#PBS -q normalbw
#PBS -P pt16
#PBS -l walltime=48:00:00
#PBS -l mem=50GB
#PBS -M galavizp@ansto.gov.au
#PBS -m abe
#PBS -l wd
#PBS -l ncpus=28
#PBS -l jobfs=1GB
#PBS -l software=lammps
#PBS -l storage=scratch/pt16+gdata/pt16
#PBS -N SiO2_4nm_H2O_r

module load openmpi/4.1.5
module load lammps/28Mar2023

n=14
mpirun -map-by ppr:$((14/$n)):numa:PE=$n lmp_openmpi -sf omp -pk omp $n -in in.lammps -nocite -log results/lammps.log
