#!/bin/bash

for sim_time in 2500 10000 15000; do

    output_dir="st_"$(echo  ${sim_time} | grep -Eo '[+-]?[0-9]+([.][0-9]+)?')
    cp -r template $output_dir
  (
    cd $output_dir || exit
    sed -i "/variable time_nvt_prod    equal/cvariable time_nvt_prod    equal ${sim_time}" in.lammps
    sed -i "/variable output_nvt_prod     equal /cvariable output_nvt_prod     equal floor(\${iterations_nvt_prod}/${sim_time})" in.lammps

    if [[ $HOSTNAME == *"tesla"* ]]; then
	    qsub -N $output_dir tesla_job.sh
    fi
    if [[ $HOSTNAME == *"gadi"* ]]; then
	    qsub -N $output_dir gadi_job.sh
    fi
    if [[ $HOSTNAME == *"setonix"* ]]; then
	    sbatch --job-name=$output_dir setonix_job.sh
    fi
  )
done