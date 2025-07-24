#!/bin/bash

for path in md_p*
do
  cd "$path" || exit;
  echo 0 | gmx trjconv -f out.gro -o out.pdb -s input.tpr
  cd ..
done

