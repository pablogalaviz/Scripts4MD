#!/usr/bin/env bash

for temperature in 100 150 200 250 300 350 400;
do

    cp ~/PycharmProjects/DB17405_H2O_nanopore/data/gromacs/pore_4nm_H2O_long_run/results/tesla/run4/md_prod_${temperature}/H2O/b_incoherent_atom_dos.h5 ${temperature}/H2O/out_dos.h5
    cp ~/PycharmProjects/DB17405_H2O_nanopore/data/gromacs/pore_4nm_H2O_long_run/results/tesla/run4/md_prod_${temperature}/SiO2/b_incoherent_atom_dos.h5 ${temperature}/SiO2/out_dos.h5
    cp ~/PycharmProjects/DB17405_H2O_nanopore/data/gromacs/pore_4nm_H2O_long_run/results/tesla/run4/md_prod_${temperature}/b_incoherent_atom_dos.h5 ${temperature}/Total/out_dos.h5

    cp ~/PycharmProjects/DB17405_H2O_nanopore/data/gromacs/pore_4nm_H2O_long_run/results/tesla/run4/md_prod_${temperature}/H2O/out_msd.h5 ${temperature}/H2O/
    cp ~/PycharmProjects/DB17405_H2O_nanopore/data/gromacs/pore_4nm_H2O_long_run/results/tesla/run4/md_prod_${temperature}/SiO2/out_msd.h5 ${temperature}/SiO2/
    cp ~/PycharmProjects/DB17405_H2O_nanopore/data/gromacs/pore_4nm_H2O_long_run/results/tesla/run4/md_prod_${temperature}/out_msd.h5 ${temperature}/Total/


      cp ~/PycharmProjects/DB17405_H2O_nanopore/data/gromacs/pore_4nm_H2O_long_run/results/tesla/run4/md_prod_${temperature}/dos_H2O.csv ${temperature}/H2O/dos.csv
      cp ~/PycharmProjects/DB17405_H2O_nanopore/data/gromacs/pore_4nm_H2O_long_run/results/tesla/run4/md_prod_${temperature}/dos_pore.csv ${temperature}/SiO2/dos.csv
      cp ~/PycharmProjects/DB17405_H2O_nanopore/data/gromacs/pore_4nm_H2O_long_run/results/tesla/run4/md_prod_${temperature}/dos_total.csv ${temperature}/Total/dos.csv

      cp ~/PycharmProjects/DB17405_H2O_nanopore/data/gromacs/pore_4nm_H2O_long_run/results/tesla/run4/md_prod_${temperature}/rmsd_H2O.csv ${temperature}/H2O/rmsd.csv
      cp ~/PycharmProjects/DB17405_H2O_nanopore/data/gromacs/pore_4nm_H2O_long_run/results/tesla/run4/md_prod_${temperature}/rmsd_pore.csv ${temperature}/SiO2/rmsd.csv
      cp ~/PycharmProjects/DB17405_H2O_nanopore/data/gromacs/pore_4nm_H2O_long_run/results/tesla/run4/md_prod_${temperature}/rmsd_total.csv ${temperature}/Total/rmsd.csv

done