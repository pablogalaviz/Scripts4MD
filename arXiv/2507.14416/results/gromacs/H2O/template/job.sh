#!/bin/bash

MAXWARN=1
export GMXLIB=$PWD/top/

#$GMX_CMD solvate -box 4 4 4 -o gro/input.gro -scale 0.6 -cs gro/tip4p.gro
#echo 8 | $GMX_CMD pdb2gmx -f ./gro/input.gro -o ./gro/input_tip4p.gro -p ./top/topol.top -custom.ff oplsaa_w_tip4p2005f

# Add solvate
$GMX_CMD insert-molecules -ci ./gro/tip4p.gro -o ./gro/input.gro -try 5000 -nmol 4000 -scale 1.0 -box 4 4 4
echo q | $GMX_CMD make_ndx -f gro/input.gro -o ndx/index.ndx
cp top/init_topol.top top/topol.top
WATER_MOLECULES=$(( $(grep -c SOL ./gro/input.gro) / 4 ))
echo -e "SOL ${WATER_MOLECULES}\n" >> ./top/topol.top

rm -rf min
mkdir min
#Energy minimization
(
$GMX_CMD grompp -f ./mdp/min.mdp -c ./gro/input.gro -r ./gro/input.gro -p ./top/topol.top -o ./min/input.tpr -po ./min/mdout.mdp -n ./ndx/index.ndx -maxwarn $MAXWARN
$GMX_MPI_CMD mdrun -s ./min/input.tpr -v -deffnm ./min/out $EXTRA_PARAMS
)

continuation="no"
init_temperature=10
prod_file=./min/out.gro
for temperature in 300 250
do
  rm -rf npt_${temperature}
  mkdir npt_${temperature}
  cp mdp/npt.mdp npt_${temperature}/input.mdp
  (
    sed -i "/annealing-temp/c annealing-temp = ${init_temperature} ${temperature}" npt_${temperature}/input.mdp
    sed -i "/ref-t/c ref-t = ${temperature}" npt_${temperature}/input.mdp
    if [[ $continuation == "yes" ]]; then
        sed -i "/gen-vel/c gen-vel              = no" npt_${temperature}/input.mdp
        sed -i "/gen-temp/d" npt_${temperature}/input.mdp
        sed -i "/gen-seed/d" npt_${temperature}/input.mdp
        sed -i "/continuation/c continuation         = yes" npt_${temperature}/input.mdp
    fi
    $GMX_CMD grompp -f npt_${temperature}/input.mdp -c $prod_file -r $prod_file -p ./top/topol.top -n ./ndx/index.ndx -po npt_${temperature}/mdout.mdp -o npt_${temperature}/input.tpr  -maxwarn $MAXWARN
    $GMX_MPI_CMD mdrun -s npt_${temperature}/input.tpr -deffnm npt_${temperature}/out $EXTRA_PARAMS


  )

  rm -rf nvt_${temperature}
  mkdir nvt_${temperature}
  cp mdp/nvt.mdp nvt_${temperature}/input.mdp
  (
    sed -i "/ref-t/c ref-t = ${temperature} " nvt_${temperature}/input.mdp
    $GMX_CMD grompp -f nvt_${temperature}/input.mdp -c ./npt_${temperature}/out.gro -r ./npt_${temperature}/out.gro -t ./npt_${temperature}/out.cpt -p ./top/topol.top -n ./ndx/index.ndx -o nvt_${temperature}/input.tpr  -maxwarn $MAXWARN
    $GMX_MPI_CMD mdrun -s nvt_${temperature}/input.tpr -deffnm nvt_${temperature}/out $EXTRA_PARAMS

  )

  rm -rf md_prod_${temperature}
  mkdir md_prod_${temperature}
  cp mdp/md_prod.mdp md_prod_${temperature}/input.mdp
  (
    sed -i "/ref-t/c ref-t = ${temperature} " md_prod_${temperature}/input.mdp
    $GMX_CMD grompp -f md_prod_${temperature}/input.mdp -c ./nvt_${temperature}/out.gro -r ./nvt_${temperature}/out.gro -t ./nvt_${temperature}/out.cpt -p ./top/topol.top -n ./ndx/index.ndx -o md_prod_${temperature}/input.tpr -maxwarn $MAXWARN
    $GMX_MPI_CMD mdrun -s md_prod_${temperature}/input.tpr -deffnm md_prod_${temperature}/out $EXTRA_PARAMS

  )
  init_temperature=$temperature
  prod_file=./md_prod_${temperature}/out.gro
  continuation="yes"
done
