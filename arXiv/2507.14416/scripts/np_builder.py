#!/usr/bin/env python3
"""
Author(s): Pablo Galaviz
Email: galavizp@ansto.gov.au
Australian Nuclear Science and Technology Organisation
"""

import argparse
import logging
import numpy as np
import os
import pandas as pd
import sys
import time

from pymatgen.core import Structure, Lattice

def format_logger():
    log_formatter = logging.Formatter('%(levelname)s [%(asctime)s] | %(message)s')
    root_logger = logging.getLogger()
    root_logger.setLevel(logging.INFO)
    return root_logger, log_formatter


def welcome(name, autors, emails):
    logging.info("-----------------------------------------------------------------")
    logging.info("     ___      .__   __.      _______.___________.  ______  ")
    logging.info("    /   \     |  \ |  |     /       |           | /  __  \ ")
    logging.info("   /  ^  \    |   \|  |    |   (----`---|  |----`|  |  |  |")
    logging.info("  /  /_\  \   |  . `  |     \   \       |  |     |  |  |  |")
    logging.info(" /  _____  \  |  |\   | .----)   |      |  |     |  `--'  |")
    logging.info("/__/     \__\ |__| \__| |_______/       |__|      \______/ ")
    logging.info("")
    logging.info("---- Australian Nuclear Science and Technology Organisation -----")
    logging.info("Nuclear science and technology for the benefit of all Australians")
## Example: ./np_builder.py -i ../data/9006189.cif -r 2 -o ../data/structures/2nm_particle -p 5
if __name__ == "__main__":

    # store start time for benchmarking
    start_time = pd.to_datetime(time.time(), unit="s")

    # setup logger
    root_logger, log_formatter = format_logger()

    # setup arguments
    epilog_text = "Australian Centre for Neutron Scattering - Scientific Computing"
    parser = argparse.ArgumentParser(description='Creates a magnetite nanoparticle of given radius', epilog=epilog_text,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('-s', '--silent', action='store_true', help='Starts in silent mode, no message will be output.')
    parser.add_argument('-d', '--debug', action='store_true', help='Shows debug info')
    parser.add_argument('-i', '--input_structure', help='CIF file of the magnetite crystal structure', required=True)
    parser.add_argument('-o', '--output', help='Output file name', required=True)
    parser.add_argument('-r', '--radius', type=float, help='Particle radius in nm', required=True)
    parser.add_argument('-p', '--padding', type=float,default=10, help='Domain padding in nm', required=False)
    parser.add_argument('-n', '--no_neutral', action='store_true', help='Do not neutralize the particle')
    parser.add_argument('-c', '--cluster', type=int,default=0, help='Make a cluster of n^3 particles')

    # parse arguments and set logger
    args = parser.parse_args()
    consoleHandler = logging.StreamHandler(sys.stdout)

    if args.debug:
        root_logger.setLevel(logging.DEBUG)

    if args.silent:
        consoleHandler.setLevel(logging.ERROR)

    consoleHandler.setFormatter(log_formatter)
    root_logger.addHandler(consoleHandler)

    welcome("np_builder", ["Pablo Galaviz"], ["galavizp@ansto.gov.au"])

    # use args.input_structure instead of fixed filepath
    if os.path.isfile(args.input_structure):
        structure = Structure.from_file(args.input_structure)
    else:
        raise FileNotFoundError(f"The file {args.input_structure} does not exist.")

    structure.add_oxidation_state_by_site([3] * 8 + [2] * 8 + [3] * 8 + [-2] * 32)
    structure.add_site_property('charge', [2.295] * 8 + [1.530] * 8 + [2.295] * 8 + [-1.530] * 32)
    unit_cell_atoms = len(structure.sites)
    structure.add_site_property('atom_number', np.arange(unit_cell_atoms))

    supercell_size=2+args.radius*20 // min(structure.lattice.abc)

    structure.make_supercell(supercell_size)
    supercells = len(structure.sites) // unit_cell_atoms
    structure.add_site_property('subcell', np.arange(supercells).tolist() * unit_cell_atoms)
    structure.add_site_property('index', np.arange(len(structure.sites)).tolist())
    lattice = structure.lattice

    cx, cy, cz = lattice.a / 2, lattice.b / 2, lattice.c / 2

    cell_state = {k: 0 for k in np.arange(supercells)}
    index_inside = []
    index_outside = []
    for i, site in enumerate(structure.sites):
        if site.distance_from_point([cy, cy, cz]) <= args.radius*10:
            subcell = site.properties['subcell']
            cell_state[subcell] += 1
            index_inside.append(i)
        else:
            index_outside.append(i)

    cell_boundary = []
    for k, v in cell_state.items():
        if v != unit_cell_atoms and v != 0:
            cell_boundary.append(k)

    composition_map = {"Fe3+": 0, "Fe2+": 0, "O2-": 0}
    factor_map = {"Fe3+": 1.5, "Fe2+": 1, "O2-": 1}
    charge_map = {"Fe3+": 0, "Fe2+": 0, "O2-": 0}
    total_charge = 0
    for indx in index_inside:
        site = structure.sites[indx]
        composition_map[site.species_string] += factor_map[site.species_string]
        charge_map[site.species_string] += site.properties["charge"]
        total_charge += site.properties["charge"]

    if not args.no_neutral:
        imbalance = composition_map["Fe3+"] + composition_map["Fe2+"] - composition_map["O2-"]
        logging.info("Particle imbalance: %d" % imbalance)
        is_integral = imbalance % 1 == 0
        if imbalance >0:
            to_add = ["O2-"] * int(imbalance)
        elif is_integral:
            to_add = ["Fe2+"] * int(abs(imbalance))
        else:
            if imbalance % 1.5 == 0:
                to_add = ["Fe3+"] * int(abs(imbalance)/1.5)
            else:
                to_add = ["Fe2+"] * int(abs(imbalance)-1.5)+["Fe3+"]

        cell_boundary_index = {k: [] for k in cell_boundary}
        for i, site in enumerate(structure.sites):
            if site.properties["subcell"] in cell_boundary_index:
                cell_boundary_index[site.properties["subcell"]].append(site.properties["index"])

        added = 0

        key_list = list(cell_boundary_index.keys())
        np.random.shuffle(key_list)
        for specie in to_add:
            if specie == "O2-":
                neighbour=["Fe2+","Fe3+"]
            else:
                neighbour=["O2-"]
            for k in key_list:
                v = cell_boundary_index[k]
                find_next = True
                for indx in v:
                    site = structure.sites[indx]
                    if site.species_string == specie and indx in index_outside:
                        connections = 0
                        for indx2 in v:
                            site2 = structure.sites[indx2]
                            if site2.species_string in neighbour and site.distance(site2) < 2.1 and site2.properties[
                                "index"] in index_inside and added < len(to_add):
                                index_outside.remove(site.properties["index"])
                                index_inside.append(site.properties["index"])
                                added += 1
                                find_next = False
                                break
                    if not find_next:
                        break

        logging.info("Particles added: %d"%added)

    particle_structure = structure.copy()
    particle_structure.remove_sites(index_outside)
    particle_structure_sorted = particle_structure.get_sorted_structure()

    total_charge = 0
    for site in particle_structure.sites:
        total_charge += site.properties["charge"]
    logging.info("Total charge: %f"%total_charge)

    coords = particle_structure_sorted.cart_coords
    min_coords = coords.min(axis=0)
    max_coords = coords.max(axis=0)

    # Add small padding (e.g., 2 Å) to avoid atoms on the boundary
    padding = args.padding  # Å
    new_lengths = (max_coords - min_coords) + padding

    # New lattice centered around the structure
    new_lattice = Lattice(new_lengths * np.eye(3))

    # Shift coordinates to start from origin + half padding
    shifted_coords = coords - min_coords + padding / 2

    new_structure = Structure(
        new_lattice,
        particle_structure_sorted.species,
        shifted_coords,
        coords_are_cartesian=True,
        site_properties=particle_structure_sorted.site_properties
    )

    if args.cluster > 0:
        new_structure.make_supercell(args.cluster)
        new_structure=new_structure.get_sorted_structure()

    atom_map = {"Fe3+": "FE3P", "Fe2+": "FE2P", "O2-": "O2M"}
    residue_map = {"Fe3+": "FE3P", "Fe2+": "FE2P", "O2-": "O2M"}
    result_str = "Fe3O4 nanoparticle r=%f\n" % (args.radius )
    result_str += "%d\n" % (len(new_structure.sites))
    total_charge = 0
    composition_map = {"Fe3+": 0, "Fe2+": 0, "O2-": 0}
    domain = np.array([[1e6, -1e6], [1e6, -1e6], [1e6, -1e6]])

    x_set, y_set, z_set = set(), set(), set()

    for i, site in enumerate(new_structure.sites):
        x, y, z = site.coords
        x_set.add(np.round(x, 8))
        y_set.add(np.round(y, 8))
        z_set.add(np.round(z, 8))

        domain[0, 0], domain[0, 1] = min(x, domain[0, 0]), max(x, domain[0, 1])
        domain[1, 0], domain[1, 1] = min(y, domain[1, 0]), max(y, domain[1, 1])
        domain[2, 0], domain[2, 1] = min(z, domain[2, 0]), max(z, domain[2, 1])
    bbox = np.diff(domain, axis=1)

    xmin = min(np.diff(np.sort(list(x_set))))
    ymin = min(np.diff(np.sort(list(y_set))))
    zmin = min(np.diff(np.sort(list(z_set))))
    for i, site in enumerate(new_structure.sites):
        total_charge += site.properties['charge']
        composition_map[site.species_string] += 1
        res_number = i + 1
        x, y, z = site.coords
        res_index = site.properties['atom_number']
        atom_name = "%s" % (atom_map[site.species_string])
        res_name = residue_map[site.species_string]
        result_str += f'{res_number%100000:>5}{res_name:<5}{atom_name:>5}{(i + 1)%100000:>5}{x / 10:8.3f}{y / 10:8.3f}{z / 10:>8.3f}\n'
    result_str += "%f %f %f\n" % (new_structure.lattice.a / 10, new_structure.lattice.b / 10, new_structure.lattice.c / 10)
    with open(args.output+".gro", "w") as gro_file:
        gro_file.write(result_str)

    bbox_padding = args.padding
    atom_type_map = {"Fe2+": 1, "Fe3+": 2, "O2-": 3}
    result_str = "Fe3O4 nanoparticle r=%f\n\n" % (args.radius )
    result_str += "%d atoms\n\n" % (len(new_structure.sites))
    result_str += "%d atom types\n\n" % (len(composition_map))
    result_str += "0 %f xlo xhi\n" % new_structure.lattice.a
    result_str += "0 %f ylo yhi\n" % new_structure.lattice.b
    result_str += "0 %f zlo zhi\n\n" % new_structure.lattice.c
    result_str += "Masses\n\n"
    result_str += "\n".join(["%d  %f" % (i + 1, mass) for i, mass in enumerate([55.8450, 55.8450, 15.9994])])
    result_str += "\n\nAtoms\n\n"
    for i, site in enumerate(new_structure.sites):
        x, y, z = site.coords
        res_index = site.properties['atom_number']
        result_str += f'{i + 1:<8}1{atom_type_map[site.species_string]:>2}{site.properties["charge"]:7.3f}{x:10.4f}{y:10.4f}{z:>10.4f}\n'

    with open(args.output+".data", "w") as lmp_file:
        lmp_file.write(result_str)

    logging.info("composition: "+",".join(["%d %s"%(v,k) for k,v in composition_map.items()]))

    logging.info("Total computation time: %s", str(pd.to_datetime(time.time(), unit="s") - start_time))
