#!/bin/bash
# CODE-RADE HTK check.
# Author : Bruce Becker
#        : https://github.com/brucellino
#        : CSIR Meraka
# ########################################
# See the README.md in the repo
# This script runs a simple check to see if
# HTK is there.
# ########################################


# These are the variables given to the job by the site. They
# may be changed - especially the LFC and LCG_GFAL_INFOSYS
# variables, which may give you different information
# for services available and file storage metadata.

echo "LFC_HOST is $LFC_HOST"
echo "Top-BDII is $LCG_GFAL_INFOSYS"
echo "LFC_TYPE is $LFC_TYPE"


echo "checking Fastrepo"
ls -lht /cvmfs/
ls -lht /cvmfs/fastrepo.sagrid.ac.za
echo "FastRepo version is"
cat /cvmfs/fastrepo.sagrid.ac.za/version
# we should have  modules from CODE-RADE

module avail

# now we check that HTK module is available

module add htk


exit 0;
