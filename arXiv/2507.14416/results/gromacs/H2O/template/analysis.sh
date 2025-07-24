#!/bin/bash

for temperature in 300 200
do

  (echo 5; echo 0) | $GMX_CMD energy -f ./min/out.edr -o ./min/potential.xvg

  (echo 11; echo 0) | $GMX_CMD energy -f ./nvt_${temperature}/out.edr -o ./nvt_${temperature}/temperature.xvg
  (echo 13; echo 0) | $GMX_CMD energy -f ./nvt_${temperature}/out.edr -o ./nvt_${temperature}/pressure.xvg

  (echo 11; echo 0) | $GMX_CMD energy -f ./npt_${temperature}/out.edr -o ./npt_${temperature}/temperature.xvg
  (echo 18; echo 0) | $GMX_CMD energy -f ./npt_${temperature}/out.edr -o ./npt_${temperature}/volume.xvg
  (echo 13; echo 0) | $GMX_CMD energy -f ./npt_${temperature}/out.edr -o ./npt_${temperature}/pressure.xvg


  (echo 11; echo 0) | $GMX_CMD energy -f ./md_prod_${temperature}/out.edr -o ./md_prod_${temperature}/temperature.xvg
  (echo 13; echo 0) | $GMX_CMD energy -f ./md_prod_${temperature}/out.edr -o ./md_prod_${temperature}/pressure.xvg

  (echo 0; echo 0) | $GMX_CMD rms -s md_prod_${temperature}/input.tpr -f md_prod_${temperature}/out.trr -o md_prod_${temperature}/rmsd_total.xvg -tu ns

  echo 0 | $GMX_CMD dos -s md_prod_${temperature}/input.tpr -f md_prod_${temperature}/out.trr -dos md_prod_${temperature}/dos_total.xvg -vacf md_prod_${temperature}/vacf_total.xvg -mvacf md_prod_${temperature}/mvacf_total.xvg -g md_prod_${temperature}/dos_total.log  -recip -T ${temperature}


done
