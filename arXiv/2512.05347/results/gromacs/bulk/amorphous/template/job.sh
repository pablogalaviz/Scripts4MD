#!/bin/bash

MAXWARN=3
export GMXLIB=$PWD/top/

# Add solvate
echo q | $GMX_CMD make_ndx -f gro/SiO2_block_6nm.gro -o ndx/index.ndx

rm -rf min
mkdir min
#Energy minimization
(
$GMX_CMD grompp -f ./mdp/min.mdp -c ./gro/SiO2_block_6nm.gro -r ./gro/SiO2_block_6nm.gro -p ./top/topol.top -o ./min/input.tpr -po ./min/mdout.mdp -n ./ndx/index.ndx -maxwarn $MAXWARN
$GMX_MPI_CMD mdrun -s ./min/input.tpr -v -deffnm ./min/out $EXTRA_PARAMS
(echo 6; echo 0) | $GMX_CMD energy -f ./min/out.edr -o ./min/potential.xvg

)

continuation="no"
init_temperature=10
out_gro_file=./min/out.gro

for temperature in 100 200 300
do
  rm -rf npt_${temperature}
  mkdir npt_${temperature}
  cp mdp/npt.mdp npt_${temperature}/input.mdp
  cp $out_gro_file npt_${temperature}/input.gro
  (
    cd npt_${temperature} || exit
    sed -i "/annealing-temp/c annealing-temp = ${init_temperature} ${temperature} " input.mdp
    sed -i "/ref-t/c ref-t = ${temperature} " input.mdp
    if [[ $continuation == "yes" ]]; then
        sed -i "/gen-vel/c gen-vel              = no" input.mdp
        sed -i "/gen-temp/d" input.mdp
        sed -i "/gen-seed/d" input.mdp
        sed -i "/continuation/c continuation         = yes" input.mdp
    fi
    $GMX_CMD grompp -f input.mdp -c input.gro -r input.gro -p ../top/topol.top -n ../ndx/index.ndx -po mdout.mdp -o input.tpr  -maxwarn $MAXWARN
    $GMX_MPI_CMD mdrun -s input.tpr -deffnm out $EXTRA_PARAMS

    (echo 11; echo 0) | $GMX_CMD energy -f out.edr -o temperature.xvg
    (echo 18; echo 0) | $GMX_CMD energy -f out.edr -o volume.xvg
    (echo 13; echo 0) | $GMX_CMD energy -f out.edr -o pressure.xvg
  )

  rm -rf nvt_${temperature}
  mkdir nvt_${temperature}
  cp mdp/nvt.mdp nvt_${temperature}/input.mdp
  cp ./npt_${temperature}/out.gro nvt_${temperature}/input.gro
  cp ./npt_${temperature}/out.cpt nvt_${temperature}/input.cpt
  (
    cd nvt_${temperature} || exit
    sed -i "/ref-t/c ref-t = ${temperature}" input.mdp
    $GMX_CMD grompp -f input.mdp -c input.gro -r input.gro -t input.cpt -p ../top/topol.top -n ../ndx/index.ndx -o input.tpr  -maxwarn $MAXWARN
    $GMX_MPI_CMD mdrun -s input.tpr -deffnm out $EXTRA_PARAMS
    (echo 11; echo 0) | $GMX_CMD energy -f out.edr -o temperature.xvg
    (echo 13; echo 0) | $GMX_CMD energy -f out.edr -o pressure.xvg
  )

  rm -rf md_prod_${temperature}
  mkdir md_prod_${temperature}
  cp mdp/md_prod.mdp md_prod_${temperature}/input.mdp
  cp nvt_${temperature}/out.gro md_prod_${temperature}/input.gro
  cp nvt_${temperature}/out.cpt md_prod_${temperature}/input.cpt
  (
    cd md_prod_${temperature} || exit
    sed -i "/ref-t/c ref-t = ${temperature}" input.mdp
    $GMX_CMD grompp -f input.mdp -c input.gro -r input.gro -t input.cpt -p ../top/topol.top -n ../ndx/index.ndx -o input.tpr -maxwarn $MAXWARN
    $GMX_MPI_CMD mdrun -s input.tpr -deffnm out $EXTRA_PARAMS

  (echo 11; echo 0) | $GMX_CMD energy -f out.edr -o temperature.xvg
  (echo 13; echo 0) | $GMX_CMD energy -f out.edr -o pressure.xvg


  echo 0 | $GMX_CMD dos -s input.tpr -f out.trr -dos dos_total.xvg -vacf vacf_total.xvg -mvacf mvacf_total.xvg -g dos_total.log  -recip -T ${temperature}

  )
  init_temperature=$temperature
  out_gro_file=./md_prod_${temperature}/out.gro
  continuation="yes"
done
