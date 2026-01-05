#!/bin/bash

MAXWARN=3
export GMXLIB=$PWD/top/
NMOL=${NMOL:-720}

# Add solvate
$GMX_CMD insert-molecules -f ./gro/pore.gro -ci ./gro/tip4p.gro -o ./gro/pore_solv.gro -try 5000 -nmol $NMOL -scale 1.0
echo q | $GMX_CMD make_ndx -f gro/pore_solv.gro -o ndx/index.ndx
cp top/init_topol.top top/topol.top
WATER_MOLECULES=$(( $(grep -c SOL ./gro/pore_solv.gro) / 4 ))
echo -e "SOL ${WATER_MOLECULES}\n" >> ./top/topol.top

rm -rf min
mkdir min
#Energy minimization
(
$GMX_CMD grompp -f ./mdp/min.mdp -c ./gro/pore_solv.gro -r ./gro/pore_solv.gro -p ./top/topol.top -o ./min/input.tpr -po ./min/mdout.mdp -n ./ndx/index.ndx -maxwarn $MAXWARN
$GMX_MPI_CMD mdrun -s ./min/input.tpr -v -deffnm ./min/out $EXTRA_PARAMS
(echo 6; echo 0) | $GMX_CMD energy -f ./min/out.edr -o ./min/potential.xvg

)

continuation="no"
init_temperature=10
out_gro_file=./min/out.gro
for temperature in 300 200 100
do
  rm -rf npt_${temperature}
  mkdir npt_${temperature}
  cp mdp/npt.mdp npt_${temperature}/input.mdp
  cp $out_gro_file npt_${temperature}/input.gro
  (
    cd npt_${temperature} || exit
    sed -i "/annealing-temp/c annealing-temp = ${init_temperature} ${temperature} ${init_temperature} ${temperature}" input.mdp
    sed -i "/ref-t/c ref-t = ${temperature} ${temperature}" input.mdp
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
    sed -i "/ref-t/c ref-t = ${temperature} ${temperature}" input.mdp
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
    sed -i "/ref-t/c ref-t = ${temperature} ${temperature}" input.mdp
    $GMX_CMD grompp -f input.mdp -c input.gro -r input.gro -t input.cpt -p ../top/topol.top -n ../ndx/index.ndx -o input.tpr -maxwarn $MAXWARN
    $GMX_MPI_CMD mdrun -s input.tpr -deffnm out $EXTRA_PARAMS

  (echo 11; echo 0) | $GMX_CMD energy -f out.edr -o temperature.xvg
  (echo 13; echo 0) | $GMX_CMD energy -f out.edr -o pressure.xvg

  (echo 0; echo -e "\n\n") | $GMX_CMD msd -dt 1 -f out.trr -s input.tpr -mol -o msd_total.xvg -mol diff_mol_total.xvg
  (echo 6; echo -e "\n\n") | $GMX_CMD msd -dt 1 -f out.trr -s input.tpr -mol -o msd_H2O.xvg -mol diff_mol_H2O.xvg
  (echo 8; echo -e "\n\n") | $GMX_CMD msd -dt 1 -f out.trr -s input.tpr -mol -o msd_pore.xvg -mol diff_mol_pore.xvg


  (echo 0; echo 0) | $GMX_CMD rms -s input.tpr -f out.trr -o rmsd_total.xvg -tu ns
  (echo 6; echo 6) | $GMX_CMD rms -s input.tpr -f out.trr -o rmsd_H2O.xvg -tu ns
  (echo 8; echo 8) | $GMX_CMD rms -s input.tpr -f out.trr -o rmsd_pore.xvg -tu ns

  echo 0 | $GMX_CMD dos -s input.tpr -f out.trr -dos dos_total.xvg -vacf vacf_total.xvg -mvacf mvacf_total.xvg -g dos_total.log  -recip -T ${temperature}
  echo 6 | $GMX_CMD dos -s input.tpr -f out.trr -dos dos_H2O.xvg -vacf vacf_H2O.xvg -mvacf mvacf_H2O.xvg -g dos_H2O.log  -recip -T ${temperature}
  echo 8 | $GMX_CMD dos -s input.tpr -f out.trr -dos dos_pore.xvg -vacf vacf_pore.xvg -mvacf mvacf_pore.xvg -g dos_pore.log  -recip -T ${temperature}

  )
  init_temperature=$temperature
  out_gro_file=./md_prod_${temperature}/out.gro
  continuation="yes"
done
