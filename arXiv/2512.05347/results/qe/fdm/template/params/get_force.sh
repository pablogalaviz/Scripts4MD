#!/bin/bash 

echo "iteration,force" > force.csv
grep "Total force"  pw.out | cut -f 2 -d "=" | tr -s " " "@" | cut -d@ -f2 | nl | tr "\t" "," >> force.csv
