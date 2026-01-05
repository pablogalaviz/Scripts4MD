#!/bin/bash
cd /home/galavizp/PycharmProjects/DB17405_H2O_nanopore/data/gromacs/pore_4nm_H2O/results/tesla/run1/wm_720
MDTools AxialDistributionHistogram --io.trajectory_input md_prod_100/out.trr --io.coordinate_input md_prod_100/out.gro --io.output analysis/rdf_100K -p parameters.ini
