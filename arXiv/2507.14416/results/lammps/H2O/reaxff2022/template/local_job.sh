#!/bin/bash
export OMPI_MCA_btl_vader_single_copy_mechanism=none
export OMPI_MCA_mpi_cuda_support=0

mpirun -np 10 --mca mpi_cuda_support 0 lmp -in in.lammps -nocite -log results/lammps.log
