#!/bin/bash

for file in pair* ;do
(
  cd "${file}"/results || exit
  grep -A 1 "E_pair" lammps.log | grep -v "E_pair" | grep -v "\-\-" | tr -s " " "," | cut -d "," -f 4 > E_pair.txt
)
done