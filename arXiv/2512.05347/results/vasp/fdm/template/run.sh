#!/bin/bash

#module load pbs

for FILE in inputs/POSCAR-*; do
  base_name="$(basename -- $FILE)"
  output_dir="disp"$(echo  $base_name | grep -Eo '[+-]?[0-9]+([.][0-9]+)?')
  cp -r params $output_dir
  cp $FILE $output_dir/POSCAR
  cd $output_dir || exit
	qsub -N "${output_dir}" job.sh
  cd ..
done
