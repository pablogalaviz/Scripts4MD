#!/bin/bash

for temperature in 300 200 100
do
  cd md_prod_${temperature} || exit;
  mkdir Total
  echo 0 | gmx trjconv -f out.gro -o Total/out.pdb -s input.tpr
  sed -i 's/SI1  SI/Si  SIO/g' Total/out.pdb
  sed -i 's/Si1  SL/Si  SIO/g' Total/out.pdb
  sed -i 's/Si1 SLG/Si  SIO/g' Total/out.pdb
  sed -i 's/            $/          Si/' Total/out.pdb
  cp out.trr Total/

  mkdir H2O
  echo 6 | gmx trjconv -f out.gro -o H2O/out.pdb -s input.tpr
  echo 6 | gmx trjconv -f out.trr -o H2O/out.trr -s input.tpr

  mkdir SiO2
  echo 8 | gmx trjconv -f out.gro -o SiO2/out.pdb -s input.tpr
  echo 8 | gmx trjconv -f out.trr -o SiO2/out.trr -s input.tpr
  sed -i 's/SI1  SI/Si  SIO/g' SiO2/out.pdb
  sed -i 's/Si1  SL/Si  SIO/g' SiO2/out.pdb
  sed -i 's/Si1 SLG/Si  SIO/g' SiO2/out.pdb
  sed -i 's/            $/          Si/' SiO2/out.pdb
  cd ..
done
