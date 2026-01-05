#!/bin/sh
#PBS -q alma9epyc64
#PBS -l walltime=500:00:00
#PBS -l nodes=1:ppn=128:alma9epyc64
#PBS -m ae
#PBS -M galavizp@ansto.gov.au
#PBS -N SiO2_aQ_reaxff_2nm_pore
#PBS -r n
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

module load lammps/intel_2022.1/23Jun2022

mpirun -hostfile ${PBS_NODEFILE} -np $(($NN/$OMP_NUM_THREADS)) lmp -sf omp -pk omp $OMP_NUM_THREADS -in in.lammps -nocite -log results/lammps.log

