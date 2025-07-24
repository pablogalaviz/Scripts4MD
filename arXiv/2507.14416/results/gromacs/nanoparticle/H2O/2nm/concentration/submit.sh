#!/bin/bash

for H2O_mols in 100 250 500 1000; do

    output_dir="H2O_"${H2O_mols}
    cp -r template $output_dir
  (
    cd $output_dir || exit
    sed -i "/H2O_MOLECULES=XXXX/cH2O_MOLECULES=${H2O_mols}" job.sh
    if [[ $HOSTNAME == *"tesla"* ]]; then
	    qsub -N $output_dir tesla_job.sh
    fi
    if [[ $HOSTNAME == *"gadi"* ]]; then
	    qsub -N $output_dir gadi_job.sh
    fi
    if [[ $HOSTNAME == *"setonix"* ]]; then
	    sbatch --job-name=$output_dir setonix_job.sh
    fi
    if [[ $HOSTNAME == *"p0034n" ]]; then
      ./local_job.sh
    fi
  )
done