#!/bin/bash

cd results || exit
for FILE in nvt_phonon_?00K.lammpstrj; do
  base_name="$(basename -- $FILE)"
  temperature=$(echo  $base_name | grep -Eo '[+-]?[0-9]+([.][0-9]+)?')

  MDTools RadialDistributionHistogram --io.trajectory_input $FILE --io.output "rdh${temperature}K" --parameters ../parameters.ini
done