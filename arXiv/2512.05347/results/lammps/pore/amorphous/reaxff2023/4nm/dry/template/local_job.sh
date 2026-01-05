#!/bin/bash
export OMPI_MCA_btl_vader_single_copy_mechanism=none
export OMP_NUM_THREADS=5
mpirun --mca mpi_cuda_support 0 -np 1  --bind-to socket lmp -sf omp -in in.lammps -nocite -log results/lammps.log
