#!/usr/bin/env bash

for temperature in 50 100 150 200 250 300
do
  MDTools PairDistributionHistogram --io.trajectory_input md_prod_${temperature}/out.trr --io.coordinate_input md_prod_${temperature}/out.gro --io.output analysis/PDF_LR/pdf_${temperature}K -p parameters.ini
done
