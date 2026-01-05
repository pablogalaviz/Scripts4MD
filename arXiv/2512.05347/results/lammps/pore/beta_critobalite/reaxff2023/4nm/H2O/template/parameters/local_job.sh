#!/bin/bash

export OMP_NUM_THREADS=6
mpirun -np 2  --bind-to socket lmp -sf omp -in in.lammps -nocite -log results/lammps.log
