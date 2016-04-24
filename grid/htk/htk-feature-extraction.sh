#!/bin/bash
# CODE-RADE HTK Feature Extraction
# Author : Bruce Becker
#        : https://github.com/brucellino
#        : CSIR Meraka
# ########################################
# See the README.md in the repo
#  This script builds on the original ASR template
#  We can stage some HTK data from UJ
#  And run feature extraction
# ########################################
start=`date +%s.%N`

# CODE-RADE needs to determine what SITE, OS and ARCH you are on.
# We need to set the following variables :
# SITE - default = generic
# OS - no default.
# ARCH - default = x86_64
SITE="generic"
OS="undefined"
ARCH="undefined"
CVMFS_DIR="undefined"
#REPO="devrepo.sagrid.ac.za"
REPO=$1.sagrid.ac.za
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
if [ -z ${MODULESHOME} ] ; then
  echo "MODULESHOME is not set. Are you sure you have modules installed ? you're going to need it."
  echo "stuff in p"
  echo "Exiting"
  exit 1;
else
  source ${MODULESHOME}/init/${shelltype}
  echo "Great, seems that modules are here, at ${MODULESHOME}"
  echo "Append CVMFS_DIR to the MODULEPATH environment"
  module use ${CVMFS_MOUNT}/${REPO}/modules/libraries
  module use ${CVMFS_MOUNT}/${REPO}/modules/compilers
fi

module add htk
module list
env | grep -i htk

which HCopy
which HCompV

curl -X POST --data-urlencode 'payload={"channel": "#gridjobs", "username": "gridjob", "text": "HTK on '"$HOSTNAME"', starting feature extraction on data chunk '"$2"' with Repo '"$1"' '"$CODERADE_VERSION"' ", "icon_emoji": ":labtocat:"}' https://hooks.slack.com/services/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
# Taking from the "system.sh" script in ASR, we first set up the workind dirs :
export DIR_EXP=$PWD

echo "Is the input data here ? "
ls -lht

for dir in  data/mfccs  log  data/proc_trans  lists/  data/audio  log ; do
  mkdir -p $dir
done

# Put the data into  data/audio
# We will use just one chunk - this is passed as the argument
echo "Staging chunk $2"
# time globus-url-copy -vb -fast -p 5 gsiftp://fs01.grid.uj.ac.za/dpm/grid.uj.ac.za/home/sagrid/hlt-nwu/data/audio/isindebele_$2.tar.gz file:$PWD/isindebele_$2.tar.gz
ls -lht isindebele_$2.tar.gz
tar xvfz isindebele_$2.tar.gz -C  data/audio/

echo ""
echo "FEATURE EXTRACTION"
# this will create a list  file associating a WAV with an "MFC" file.
# this list is kept in a file - hcopylist.lst
# It is done by running a perl script
echo "creating hcopylist.lst"
date >>  log/time.feat
perl  create_hcopy_lists.pl  data/audio  data/mfccs  lists/hcopylist.lst

echo "what's in the hcopylist ? "
cat lists/hcopy.lst

echo "running: CMVN.sh cmvn"
chmod +x CMVN.sh cmn.sh cvn.sh create_configs.sh check_exit_status.sh
ls $DIR_EXP
echo "DIR SRC = $DIR_SRC"
time ./CMVN.sh cmvn  lists/hcopylist.lst | tee  log/feature.log
date >>  log/time.feat
cat log/time.feat
end=`date +%s.%N`
time=`echo "$end - $start" | bc`
curl -X POST --data-urlencode 'payload={"channel": "#gridjobs", "username": "gridjob", "text": "Feature extraction of data chunk '"$2"' on '"$HOSTNAME"' took '"$time"' s. :wave::skin-tone-6:  ", "icon_emoji": ":labtocat:" }' https://hooks.slack.com/services/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

exit 0;
