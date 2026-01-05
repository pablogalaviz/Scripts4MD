#!/bin/bash

for water_molecules in 45 90 180 360 720 1440
do
  directory="wm_${water_molecules}"
  rm -rf $directory
  cp -r parameters $directory
  (
    cd $directory || exit
    qsub -v "NMOL=${water_molecules}" -N ${directory} tesla_job.sh
  )

done