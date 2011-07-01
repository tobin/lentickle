lentickle - length loop modeling

DEPENDENCIES:

Optickle          - https://awiki.ligo-wa.caltech.edu/aLIGO/ISC_Modeling_Software 
nicmatlabscripts  - git clone git://github.com/nicolassmith/nicmatlabscripts.git
eligomeasurements - git clone git://github.com/tobin/eligomeasurements.git

TO SET UP:

edit setupLentickle so that the path to Optickle and the path to 
nicmatlabscripts are correct.

If "Optickle", "nicmatlabscripts", and "eligomeasurements" are subdirectories
or simlinks in the lentickle root, then lentickle will find them.

TO RUN:

Try the intensitycouplingplots.m for an example script.

Most of the work happens in getEligoResults.m though...
