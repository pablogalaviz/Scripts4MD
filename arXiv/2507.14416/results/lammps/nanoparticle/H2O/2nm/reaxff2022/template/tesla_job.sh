#!/bin/sh
#PBS -q alma9epyc256
#PBS -l walltime=500:00:00
#PBS -l nodes=1:ppn=256:alma9epyc256
#PBS -m ae
#PBS -M galavizp@ansto.gov.au
#PBS -N reaxff22Fe3O4_np_2nm
#PBS -r n
cd $PBS_O_WORKDIR

export NN=`cat $PBS_NODEFILE | wc -l`

export OMP_NUM_THREADS=8

module use /data1/packages/galavizp/Modules
module use /data1/packages/galavizp/intel/oneapi/modulefiles

module load lammps/intel_2022.1/23Jun2022_alma

mpirun -hostfile ${PBS_NODEFILE} -np $(($NN/$OMP_NUM_THREADS)) lmp -sf omp -pk omp $OMP_NUM_THREADS -in in.lammps -nocite > results/lammps.log
