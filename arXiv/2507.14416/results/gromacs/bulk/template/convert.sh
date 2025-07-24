#!/bin/bash

for directory in npt_*
do
  (
  cd $directory || exit
  xvg2csv.sh temperature.xvg
  xvg2csv.sh pressure.xvg
  xvg2csv.sh volume.xvg
  )
done


for directory in nvt_*
do
  (
  cd $directory || exit
  xvg2csv.sh temperature.xvg
  xvg2csv.sh pressure.xvg
  )
done

for directory in md_prod_*
do
  (
  cd $directory || exit
  xvg2csv.sh temperature.xvg
  xvg2csv.sh pressure.xvg

  xvg2csv.sh dos_H2O.xvg

  xvg2csv.sh rmsd_total.xvg

  xvg2csv.sh msd_total.xvg

  )
done
