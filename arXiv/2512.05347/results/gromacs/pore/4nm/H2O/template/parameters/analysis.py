#!/usr/local/bin/python

########################################################
# This is an automatically generated MDANSE run script #
########################################################

from MDANSE import REGISTRY

def convert(runset,temperature,system):
    parameters = {}
    parameters['fold'] = True
    parameters['output_file'] = (u'%s_%d/%s/out' % (runset, temperature,system), 'netcdf')
    parameters['pdb_file'] = u'%s_%d/%s/out.pdb' % (runset, temperature,system)
    parameters['xtc_file'] = u'%s_%d/%s/out.trr' % (runset, temperature,system)

    ################################################################
    # Setup and run the analysis                                   #
    ################################################################
    print("converting %s %s data at %dK" % (runset,system,temperature))

    gromacs = REGISTRY['job']['gromacs']()
    gromacs.run(parameters, status=True)


def dos(temperature,weights,system):
    parameters = {}
    parameters['atom_selection'] = None
    parameters['atom_transmutation'] = None
    parameters['frames'] = (0, 5000, 1)
    parameters['grouping_level'] = u'atom'
    parameters['instrument_resolution'] = ('ideal', {})
    parameters['interpolation_order'] = u'no interpolation'
    parameters['output_files'] = (u'md_prod_%d/%s/%s_dos'%(temperature,system,weights), (u'hdf',))
    parameters['projection'] = None
    parameters['running_mode'] = ('monoprocessor',)
    parameters['trajectory'] = u'md_prod_%d/%s/out.nc'%(temperature,system)
    parameters['weights'] = weights

    ################################################################
    # Setup and run the analysis                                   #
    ################################################################

    print("processing dos at %dK %s %s"%(temperature,system,weights))
    dos = REGISTRY['job']['dos']()
    dos.run(parameters,status=True)


################################################################
# Job parameters                                               #
################################################################
for temperature in [100,  200,  300]:
    for system in ["H2O","Total","SiO2"]:

        convert("md_prod",temperature,system)
        dos(temperature,"b_coherent",system)
        dos(temperature,"b_incoherent",system)

