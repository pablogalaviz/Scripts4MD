#!/usr/bin/env bash

for temperature in 100 150 200 250 300
do
  MDTools AxialDistributionHistogram --io.input nvt_prod_${temperature}K.lammpstrj.gz --io.output rdf_${temperature}K -p parameters.ini
done