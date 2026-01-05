#!/bin/bash
#PBS -q alma9epyc64
#PBS -l walltime=500:00:00
#PBS -l nodes=1:ppn=128:alma9epyc64
#PBS -m ae
#PBS -M galavizp@ansto.gov.au
#PBS -N pore_4nm_H2O
#PBS -r n
#PBS -o stdout.txt
#PBS -e stderr.txt

cd $PBS_O_WORKDIR

export NN=`cat $PBS_NODEFILE | wc -l`

export I_MPI_PIN_DOMAIN=omp
export I_MPI_PIN=yes
export KMP_AFFINITY=disabled
export OMP_NUM_THREADS=4
export MP_BIND=yes
export MP_BLIST="0,1,2,3"

module use /data1/packages/galavizp/Modules
module use /data1/packages/galavizp/intel/oneapi/modulefiles
module load gromacs/intel_2022.1/2024.3

export GMX_CMD="gmx"
export GMX_MPI_CMD="mpirun -n $(($NN / $OMP_NUM_THREADS)) gmx"
export EXTRA_PARAMS=" -pin on -ntomp $OMP_NUM_THREADS"
export NMOL=${NMOL:-720}


source ./job.sh