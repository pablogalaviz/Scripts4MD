#!/bin/bash

for timestep in 0.0005 0.001 0.002; do

    output_dir="dt_"$(echo  $timestep | grep -Eo '[+-]?[0-9]+([.][0-9]+)?')
    cp -r template $output_dir
  (
    cd $output_dir || exit
    sed -i "/variable dt               equal/cvariable dt               equal ${timestep}" in.lammps
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