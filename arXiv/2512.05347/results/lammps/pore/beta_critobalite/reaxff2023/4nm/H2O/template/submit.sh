#!/bin/bash

for water_molecules in 45 90 180 360 720 1440
do
  directory="wm_${water_molecules}"
  rm -rf $directory
  cp -r parameters $directory
  (
    cd $directory || exit
    sed -i "s/^variable number_of_H2O equal [0-9]\+/variable number_of_H2O equal ${water_molecules}/" in.lammps
    qsub -N "ReaxFF2023_"${directory} tesla_job.sh
  )

done