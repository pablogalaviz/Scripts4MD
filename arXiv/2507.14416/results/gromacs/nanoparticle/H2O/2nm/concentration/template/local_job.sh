#!/bin/bash

export OMP_NUM_THREADS=2
export MPI_NUM_CORES=4
export GMX_CMD="gmx_d -quiet"
export GMX_MPI_CMD="gmx_d -quiet"
export EXTRA_PARAMS=" -pin on -ntomp $OMP_NUM_THREADS"

source ./job.sh