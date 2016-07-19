#!/bin/bash
# CODE-RADE Grid Example 1
# Author : Bruce Becker
#        : https://github.com/brucellino
#        : CSIR Meraka
# ########################################
# See the README.md in the repo
# This script runs basic checks on a site
# and tells the user what the version of
# fastrepo is that is currently available
# ########################################

# We give some verbose context to the user -
# who were you mapped as and which worker node are you
# running on. The 'sleep' is just there to give the job
# time to appear as "running" on the site - else it
# exits too quickly for the user or site admin to notice
# this is a purely debugging choice.
sleep 5
echo "I am "
whoami
echo " on "
hostname -f

REPO="fastrepo.sagrid.ac.za"
echo "LFC_HOST is $LFC_HOST"
echo "Top-BDII is $LCG_GFAL_INFOSYS"
echo "LFC_TYPE is $LFC_TYPE"


echo "We assuming CVMFS is installed, so we getting the CVMFS mount point"
CVMFS_MOUNT=`cvmfs_config showconfig $REPO|grep CVMFS_MOUNT_DIR|awk -F '=' '{print $2}'|awk -F ' ' '{print $1}'`

echo $SITE
echo $OS
echo $ARCH
echo $CVMFS_MOUNT
echo $REPO

export SITE
export OS
export ARCH
export CVMFS_DIR=${CVMFS_MOUNT}/${REPO}
export REPO
export TMPDIR
echo "you are using ${REPO} version"
cat /cvmfs/${REPO}/version
echo "Checking whether you have modules installed"
CODERADE_VERSION=`cat /cvmfs/${REPO}/version`
# Is "modules even available? "
if [ -z ${MODULESHOME} ] ; then
  echo "MODULESHOME is not set. Are you sure you have modules installed ? you're going to need it."
  echo "stuff in p"
  echo "Exiting"
  exit 1;
else
  source ${MODULESHOME}/init/${shelltype}
  echo "Great, seems that modules are here, at ${MODULESHOME}"
  echo "Append CVMFS_DIR to the MODULEPATH environment"
  module use ${CVMFS_DIR}/modules/compilers
  module use ${CVMFS_DIR}/modules/libraries
  module use ${CVMFS_DIR}/modules/bioinformatics
  module use ${CVMFS_DIR}/modules/astro
  module use ${CVMFS_DIR}/modules/physical-sciences
  module use ${CVMFS_DIR}/modules/chemistry

fi

module avail FMD
module add FMD
exit 0;
