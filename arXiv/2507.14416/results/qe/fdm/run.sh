#!/bin/bash

for FILE in inputs/supercell-*; do 
  base_name="$(basename -- $FILE)"
  output_dir="disp"$(echo  $base_name | grep -Eo '[+-]?[0-9]+([.][0-9]+)?')
  cp -r template $output_dir
  cat template/pw.header.in $FILE > $output_dir/pw.in
  cd $output_dir || exit
  	qsub -N "Fe3O4_${output_dir}" job.sh
  cd ..
done
