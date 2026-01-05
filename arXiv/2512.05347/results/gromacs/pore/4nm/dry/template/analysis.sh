#!/bin/bash

for temperature in 300 250 200 150 100 50
do

  (echo 6; echo 0) | $GMX_CMD energy -f ./min/out.edr -o ./min/potential.xvg

  (echo 11; echo 0) | $GMX_CMD energy -f ./nvt_${temperature}/out.edr -o ./nvt_${temperature}/temperature.xvg
  (echo 13; echo 0) | $GMX_CMD energy -f ./nvt_${temperature}/out.edr -o ./nvt_${temperature}/pressure.xvg

  (echo 11; echo 0) | $GMX_CMD energy -f ./npt_${temperature}/out.edr -o ./npt_${temperature}/temperature.xvg
  (echo 18; echo 0) | $GMX_CMD energy -f ./npt_${temperature}/out.edr -o ./npt_${temperature}/volume.xvg
  (echo 13; echo 0) | $GMX_CMD energy -f ./npt_${temperature}/out.edr -o ./npt_${temperature}/pressure.xvg


  (echo 11; echo 0) | $GMX_CMD energy -f ./md_prod_${temperature}/out.edr -o ./md_prod_${temperature}/temperature.xvg
  (echo 13; echo 0) | $GMX_CMD energy -f ./md_prod_${temperature}/out.edr -o ./md_prod_${temperature}/pressure.xvg

#  (echo 0; echo 0) | $GMX_CMD rms -s md_prod_${temperature}/input.tpr -f md_prod_${temperature}/out.trr -o md_prod_${temperature}/rmsd_total.xvg -tu ns
#  (echo 6; echo 6) | $GMX_CMD rms -s md_prod_${temperature}/input.tpr -f md_prod_${temperature}/out.trr -o md_prod_${temperature}/rmsd_H2O.xvg -tu ns
#  (echo 8; echo 8) | $GMX_CMD rms -s md_prod_${temperature}/input.tpr -f md_prod_${temperature}/out.trr -o md_prod_${temperature}/rmsd_pore.xvg -tu ns

#  echo 0 | $GMX_CMD dos -s md_prod_${temperature}/input.tpr -f md_prod_${temperature}/out.trr -dos md_prod_${temperature}/dos_total.xvg -vacf md_prod_${temperature}/vacf_total.xvg -mvacf md_prod_${temperature}/mvacf_total.xvg -g md_prod_${temperature}/dos_total.log  -recip -T ${temperature}
#  echo 6 | $GMX_CMD dos -s md_prod_${temperature}/input.tpr -f md_prod_${temperature}/out.trr -dos md_prod_${temperature}/dos_H2O.xvg -vacf md_prod_${temperature}/vacf_H2O.xvg -mvacf md_prod_${temperature}/mvacf_H2O.xvg -g md_prod_${temperature}/dos_H2O.log  -recip -T ${temperature}
#  echo 8 | $GMX_CMD dos -s md_prod_${temperature}/input.tpr -f md_prod_${temperature}/out.trr -dos md_prod_${temperature}/dos_pore.xvg -vacf md_prod_${temperature}/vacf_pore.xvg -mvacf md_prod_${temperature}/mvacf_pore.xvg -g md_prod_${temperature}/dos_pore.log  -recip -T ${temperature}


done
