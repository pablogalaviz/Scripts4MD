#!/bin/bash

MAXWARN=1
export GMXLIB=$PWD/top/

echo q | $GMX_CMD make_ndx -f gro/input.gro -o ndx/index.ndx

rm -rf min
mkdir min
#Energy minimization
(
$GMX_CMD grompp -f ./mdp/min.mdp -c ./gro/input.gro -r ./gro/input.gro -p ./top/topol.top -o ./min/input.tpr -po ./min/mdout.mdp -n ./ndx/index.ndx -maxwarn $MAXWARN
$GMX_MPI_CMD mdrun -s ./min/input.tpr -v -deffnm ./min/out $EXTRA_PARAMS
(echo 4; echo 0) | $GMX_CMD energy -f ./min/out.edr -o ./min/potential.xvg

)

continuation="no"
init_temperature=10
prod_file=./min/out.gro
for temperature in 300 200
do
  rm -rf npt_${temperature}
  mkdir npt_${temperature}
  cp mdp/npt.mdp npt_${temperature}/input.mdp
  (
    sed -i "/annealing-temp/c annealing-temp = ${init_temperature} ${temperature} " npt_${temperature}/input.mdp
    sed -i "/ref-t/c ref-t = ${temperature}" npt_${temperature}/input.mdp
    if [[ $continuation == "yes" ]]; then
        sed -i "/gen-vel/c gen-vel              = no" npt_${temperature}/input.mdp
        sed -i "/gen-temp/d" npt_${temperature}/input.mdp
        sed -i "/gen-seed/d" npt_${temperature}/input.mdp
        sed -i "/continuation/c continuation         = yes" npt_${temperature}/input.mdp
    fi
    $GMX_CMD grompp -f npt_${temperature}/input.mdp -c $prod_file -r $prod_file -p ./top/topol.top -n ./ndx/index.ndx -po npt_${temperature}/mdout.mdp -o npt_${temperature}/input.tpr  -maxwarn $MAXWARN
    $GMX_MPI_CMD mdrun -s npt_${temperature}/input.tpr -deffnm npt_${temperature}/out $EXTRA_PARAMS

  (echo 9; echo 0) | $GMX_CMD energy -f ./npt_${temperature}/out.edr -o ./npt_${temperature}/temperature.xvg
  (echo 15; echo 0) | $GMX_CMD energy -f ./npt_${temperature}/out.edr -o ./npt_${temperature}/volume.xvg
  (echo 11; echo 0) | $GMX_CMD energy -f ./npt_${temperature}/out.edr -o ./npt_${temperature}/pressure.xvg

  )

  rm -rf nvt_${temperature}
  mkdir nvt_${temperature}
  cp mdp/nvt.mdp nvt_${temperature}/input.mdp
  (
    sed -i "/ref-t/c ref-t = ${temperature} " nvt_${temperature}/input.mdp
    $GMX_CMD grompp -f nvt_${temperature}/input.mdp -c ./npt_${temperature}/out.gro -r ./npt_${temperature}/out.gro -t ./npt_${temperature}/out.cpt -p ./top/topol.top -n ./ndx/index.ndx -o nvt_${temperature}/input.tpr  -maxwarn $MAXWARN
    $GMX_MPI_CMD mdrun -s nvt_${temperature}/input.tpr -deffnm nvt_${temperature}/out $EXTRA_PARAMS
    (echo 9; echo 0) | $GMX_CMD energy -f ./nvt_${temperature}/out.edr -o ./nvt_${temperature}/temperature.xvg
    (echo 11; echo 0) | $GMX_CMD energy -f ./nvt_${temperature}/out.edr -o ./nvt_${temperature}/pressure.xvg

  )

  rm -rf md_prod_${temperature}
  mkdir md_prod_${temperature}
  cp mdp/md_prod.mdp md_prod_${temperature}/input.mdp
  (
    sed -i "/ref-t/c ref-t = ${temperature} " md_prod_${temperature}/input.mdp
    $GMX_CMD grompp -f md_prod_${temperature}/input.mdp -c ./nvt_${temperature}/out.gro -r ./nvt_${temperature}/out.gro -t ./nvt_${temperature}/out.cpt -p ./top/topol.top -n ./ndx/index.ndx -o md_prod_${temperature}/input.tpr -maxwarn $MAXWARN
    $GMX_MPI_CMD mdrun -s md_prod_${temperature}/input.tpr -deffnm md_prod_${temperature}/out $EXTRA_PARAMS

  (echo 9; echo 0) | $GMX_CMD energy -f ./md_prod_${temperature}/out.edr -o ./md_prod_${temperature}/temperature.xvg
  (echo 11; echo 0) | $GMX_CMD energy -f ./md_prod_${temperature}/out.edr -o ./md_prod_${temperature}/pressure.xvg

  (echo 0; echo -e "\n\n") | $GMX_CMD msd -dt 1 -f md_prod_${temperature}/out.trr -s md_prod_${temperature}/input.tpr -mol -o md_prod_${temperature}/msd_total.xvg -mol md_prod_${temperature}/diff_mol_total.xvg

  (echo 0; echo 0) | $GMX_CMD rms -s md_prod_${temperature}/input.tpr -f md_prod_${temperature}/out.trr -o md_prod_${temperature}/rmsd_total.xvg -tu ns

  )

  rm -rf md_phonon_${temperature}
  mkdir md_phonon_${temperature}
  cp mdp/md_phonon.mdp md_phonon_${temperature}/input.mdp
  (
    sed -i "/ref-t/c ref-t = ${temperature} " md_phonon_${temperature}/input.mdp
    $GMX_CMD grompp -f md_phonon_${temperature}/input.mdp -c ./md_prod_${temperature}/out.gro -r ./md_prod_${temperature}/out.gro -t ./md_prod_${temperature}/out.cpt -p ./top/topol.top -n ./ndx/index.ndx -o md_phonon_${temperature}/input.tpr -maxwarn $MAXWARN
    $GMX_MPI_CMD mdrun -s md_phonon_${temperature}/input.tpr -deffnm md_phonon_${temperature}/out $EXTRA_PARAMS

  (echo 9; echo 0) | $GMX_CMD energy -f ./md_phonon_${temperature}/out.edr -o ./md_phonon_${temperature}/temperature.xvg
  (echo 11; echo 0) | $GMX_CMD energy -f ./md_phonon_${temperature}/out.edr -o ./md_phonon_${temperature}/pressure.xvg

  echo 0 | $GMX_CMD dos -s md_phonon_${temperature}/input.tpr -f md_phonon_${temperature}/out.trr -dos md_phonon_${temperature}/dos_total.xvg -vacf md_phonon_${temperature}/vacf_total.xvg -mvacf md_phonon_${temperature}/mvacf_total.xvg -g md_phonon_${temperature}/dos_total.log  -recip -T ${temperature}

  )

  init_temperature=$temperature
  prod_file=./md_phonon_${temperature}/out.gro
  continuation="yes"
done
