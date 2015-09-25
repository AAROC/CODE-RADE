#!/bin/bash
# Script to set a few variables on the deploy side.
# this needs to find out what kind of machine it's been executed on and set the path to the
# CODE-RADE modules.

# If CVMFS is mounted at $CVMFS_MOUNT - usually /cvmfs then the modules are at
# /cvmfs/<repo name>/modules


# Is "modules even available? "
if [ ! -n ${MODULESHOME} ] ; then
  echo "MODULESHOME is not set. Are you sure you have modules installed ? you're going to need it."
fi
