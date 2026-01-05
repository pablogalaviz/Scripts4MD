#!/bin/bash

#module load pbs

for FILE in inputs/supercell-*; do 
  base_name="$(basename -- $FILE)"
  output_dir="disp"$(echo  $base_name | grep -Eo '[+-]?[0-9]+([.][0-9]+)?')
  cp -r params $output_dir
  cat params/pw.header.in $FILE > $output_dir/pw.in
  cd $output_dir || exit
  qsub -N "${output_dir}" job.sh
  cd ..
done
