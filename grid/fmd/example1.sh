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

echo "LFC_HOST is $LFC_HOST"
echo "Top-BDII is $LCG_GFAL_INFOSYS"
echo "LFC_TYPE is $LFC_TYPE"


echo "We assuming CVMFS is installed, so we getting the CVMFS mount point"
CVMFS_MOUNT=`cvmfs_config showconfig $REPO|grep CVMFS_MOUNT_DIR|awk -F '=' '{print $2}'|awk -F ' ' '{print $1}'`
echo "CVMFS_MOUNT is "
echo ${CVMFS_MOUNT}

SITE="generic"
OS="undefined"
ARCH="undefined"
CVMFS_DIR="undefined"
#REPO="devrepo.sagrid.ac.za"
REPO=fastrepo.sagrid.ac.za
shelltype=`echo $SHELL | awk 'BEGIN { FS = "/" } {print $3}'`
echo "looks like you're using $shelltype"
# What architecture are we ?
ARCH=`uname -m`
# It's possible, but very unlikely that some wierdo wants to do this on a machine that's not
# Linux - let's provide for this instance
if [ $? != 0 ] ; then
  echo "My my, uname exited with a nonzero code. \n Are you trying to run this from a non-Linux machine ? \n Dude ! What's WRONG with you !? \n\n Bailing out... aaaaahhhhhrrrggg...."
  exit 127
fi

# What OS are we on ?
# Strategy -
# 1. If LSB is present, use that - probably only the case for ubuntu machines
# 2. if not check /etc/debian_version
# 3. If not, check /etc/redhat_release - if there, check the version

# we go in order of likelihood... probably going to be CentOS machines before they're actually
# RH machines.
# TODO : condition for SuSE or Fedora machines. (ok, we don't compile against those yet)

# can haz LSB ?
LSB_PRESENT=`which lsb_release`
if [ $? != 0 ] ; then
  echo "No LSB found, checking files in /etc/"
  LSB_PRESENT=false
  # probably CEntOS /etc/redhat_release ?
  if [[ -h /etc/redhat-release  &&  -s /etc/centos-release ]] ; then
    echo "We're on a CEntOS machine"
    CENTOS_VERSION=`rpm -q --queryformat '%{VERSION}' centos-release`
    echo $CENTOS_VERSION
    # ok, close enough, we're on sl6
    OS="sl6"
    #  Time to suggest a compiler. Use /proc/version
  fi # We've set OS=sl6 and it's probably a CentOS machine. TODO : test on different machines for false positives.
  # We're probably a debian machine at this point
  if [ -s /etc/debian_release ] ; then
    echo "/etc/debian_release is present - seems to be a debian machine"
    IS_DEBIAN=true
    DEBIAN_VERSION=`cat /etc/debian_version | awk -F . '{print $1}'`
    if [ ${DEBIAN_VERSION} == 6 ] ; then
      echo "This seems to be Debian 6"
      echo "Setting your OS to u1404 - close enough"
    else
      echo "Debian version ${DEBIAN_VERSION} is not supported"
      exit 127
    fi
  fi
else # lsb is present
  LSB_ID=`lsb_release -is`
  LSB_RELEASE=`lsb_release -rs`
  echo "You seem to be on ${LSB_ID}, version ${LSB_RELEASE}..."
  if [[ ${LSB_ID} == 'Ubuntu' && ${LSB_RELEASE} == '14.04' ]] ; then
    echo "Cool, we test this, welcome :) ; Setting OS=u1404"
    OS="u1404"
  elif [[ ${LSB_ID} == 'Ubuntu' ]] ; then
     echo "Dude, you seem to be using an Ubuntu machine, but not the one we test for."
     echo "Setting OS to u1404... YMMV"
     echo "If you want to have this target certified, please request it of the devs "
     echo "by opening a ticket at https://github.com/AAROC/CODE-RADE/issues/new"
     OS="u1404"
  elif [[ ${LSB_ID} == 'CentOS' || ${LSB_ID} == 'Scientific' || ${LSB_ID} == 'REDHAT' ]] ; then
    echo "RPM based machine, now checking the release version"
    if [[ $(echo $LSB_RELEASE '>=' 6 |bc) -eq 1 ]] ; then
       echo "We can support your version"
       OS="sl6"
    else
      echo "The minimum release version we support is 6, sorry, please upgrade"
    fi
  else
   echo "Ahem...."
 fi

fi

if [ ${OS} == 'undefined' ] ; then
  echo "damn, OS is still undefined"
  echo "look dude, You're not CentOS , you're not Debian and you don't have LSB... CVMFS is not your problem right now."
  exit 127
fi


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
echo "you are using CODE-RADE version $CODERADE_VERSION"
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

which minenergy
ls $FMD_DIR
exit 0;
