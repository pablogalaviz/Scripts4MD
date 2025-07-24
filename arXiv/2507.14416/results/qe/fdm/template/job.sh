#!/bin/sh
#PBS -q default
#PBS -l walltime=400:00:00
#PBS -l nodes=1:ppn=64
#PBS -m ae
#PBS -N qe_Fe3O4_relax_r
#PBS -r n
cd $PBS_O_WORKDIR

export NN=`cat $PBS_NODEFILE | wc -l`

export I_MPI_PIN_DOMAIN=omp
export I_MPI_PIN=yes

export KMP_AFFINITY=disabled
export OMP_NUM_THREADS=4
export MP_BIND=yes
export MP_BLIST="0,1,2,3"

module load qe/intel_2022.1/7.0

ulimit -s unlimited

mpirun -hostfile $PBS_NODEFILE -np $(($NN/$OMP_NUM_THREADS)) pw.x -in pw.in > pw.out