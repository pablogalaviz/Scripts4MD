#!/bin/bash

MAXWARN=1
export GMXLIB=$PWD/top/

#$GMX_CMD editconf -f ./gro/input.gro -o ./gro/input_box.gro -box 2.5 2.5 2.5 -pbc
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
prev_path=../min
for temperature in 300 200
do
  for pressure in 1 5 10 50 100 500
  do
    path=npt_${temperature}_${pressure}
    rm -rf ${path}
    mkdir ${path}
    cp mdp/npt.mdp ${path}/input.mdp
    (
      cd ${path} || exit
      sed -i "/annealing-temp/c annealing-temp = ${init_temperature} ${temperature} " input.mdp
      sed -i "/ref-t/c ref-t = ${temperature}" input.mdp
      sed -i "/ref-p/c ref-p = ${pressure}" input.mdp

      if [[ $continuation == "yes" ]]; then
          sed -i "/gen-vel/c gen-vel              = no" input.mdp
          sed -i "/gen-temp/d" input.mdp
          sed -i "/gen-seed/d" input.mdp
          sed -i "/continuation/c continuation         = yes" input.mdp
      fi
      $GMX_CMD grompp -f input.mdp -c ${prev_path}/out.gro -r ${prev_path}/out.gro -p ../top/topol.top -n ../ndx/index.ndx -po mdout.mdp -o input.tpr  -maxwarn $MAXWARN
      $GMX_MPI_CMD mdrun -s input.tpr -deffnm out $EXTRA_PARAMS

    (echo 9; echo 0) | $GMX_CMD energy -f out.edr -o temperature.xvg
    (echo 15; echo 0) | $GMX_CMD energy -f out.edr -o volume.xvg
    (echo 11; echo 0) | $GMX_CMD energy -f out.edr -o pressure.xvg

    )

    prev_path=../${path}
    path=nvt_${temperature}_${pressure}
    rm -rf ${path}
    mkdir ${path}
    cp mdp/nvt.mdp ${path}/input.mdp
    (
      cd ${path} || exit
      sed -i "/ref-t/c ref-t = ${temperature} " input.mdp
      $GMX_CMD grompp -f input.mdp -c ${prev_path}/out.gro -r ${prev_path}/out.gro -t ${prev_path}/out.cpt -p ../top/topol.top -n ../ndx/index.ndx -o input.tpr  -maxwarn $MAXWARN
      $GMX_MPI_CMD mdrun -s input.tpr -deffnm out $EXTRA_PARAMS
      (echo 9; echo 0) | $GMX_CMD energy -f out.edr -o temperature.xvg
      (echo 11; echo 0) | $GMX_CMD energy -f out.edr -o pressure.xvg
    )

    prev_path=../${path}
    path=md_prod_${temperature}_${pressure}
    rm -rf ${path}
    mkdir ${path}
    cp mdp/md_prod.mdp ${path}/input.mdp
    (
      cd ${path} || exit
      sed -i "/ref-t/c ref-t = ${temperature} " input.mdp
      $GMX_CMD grompp -f input.mdp -c ${prev_path}/out.gro -r ${prev_path}/out.gro -t ${prev_path}/out.cpt -p ../top/topol.top -n ../ndx/index.ndx -o input.tpr -maxwarn $MAXWARN
      $GMX_MPI_CMD mdrun -s input.tpr -deffnm out $EXTRA_PARAMS

    (echo 9; echo 0) | $GMX_CMD energy -f out.edr -o temperature.xvg
    (echo 11; echo 0) | $GMX_CMD energy -f out.edr -o pressure.xvg

    (echo 0; echo -e "\n\n") | $GMX_CMD msd -dt 1 -f out.trr -s input.tpr -mol -o msd_total.xvg -mol diff_mol_total.xvg

    (echo 0; echo 0) | $GMX_CMD rms -s input.tpr -f out.trr -o rmsd_total.xvg -tu ns

    )

    prev_path=../${path}
    path=md_phonon_${temperature}_${pressure}
    rm -rf ${path}
    mkdir ${path}
    cp mdp/md_phonon.mdp ${path}/input.mdp
    (
      cd ${path} || exit
      sed -i "/ref-t/c ref-t = ${temperature} " input.mdp
      $GMX_CMD grompp -f input.mdp -c ${prev_path}/out.gro -r ${prev_path}/out.gro -t ${prev_path}/out.cpt -p ../top/topol.top -n ../ndx/index.ndx -o input.tpr -maxwarn $MAXWARN
      $GMX_MPI_CMD mdrun -s input.tpr -deffnm out $EXTRA_PARAMS

    (echo 9; echo 0) | $GMX_CMD energy -f out.edr -o temperature.xvg
    (echo 11; echo 0) | $GMX_CMD energy -f out.edr -o pressure.xvg

    echo 0 | $GMX_CMD dos -s input.tpr -f out.trr -dos dos_total.xvg -vacf vacf_total.xvg -mvacf mvacf_total.xvg -g dos_total.log  -recip -T ${temperature}

    )

    init_temperature=$temperature
    prev_path=../${path}
    continuation="yes"
  done
done
