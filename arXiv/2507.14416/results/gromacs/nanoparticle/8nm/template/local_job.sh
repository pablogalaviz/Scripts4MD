#!/bin/bash

export OMP_NUM_THREADS=2
export MPI_NUM_CORES=4
export GMX_CMD="gmx -quiet"
export GMX_MPI_CMD="gmx -quiet"
export EXTRA_PARAMS=" -pin on -ntomp $OMP_NUM_THREADS"

source ./job.sh