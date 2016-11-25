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

echo "this is my environment : "
env

echo "LFC_HOST is $LFC_HOST"
echo "Top-BDII is $LCG_GFAL_INFOSYS"
echo "LFC_TYPE is $LFC_TYPE"


echo "checking mounts"
cat /etc/fstab
mount -l
echo "checking cvmfs config"
ls /etc/cvmfs
cat /etc/cvmfs/default.local
cat /etc/cvmfs/config.d/fastrepo.sagrid.ac.za.conf
file /etc/auto.cvmfs
cat /etc/auto.cvmfs
cat /etc/auto.master
echo "checking whether cvmfs is running"
/etc/init.d/autofs status

echo " is /cvmfs even there ? "
ls -lht /
ls -lht /cvmfs

echo "checking Fastrepo"
echo "FastRepo version is"
cat /cvmfs/fastrepo.sagrid.ac.za/version
source  /cvmfs/fastrepo.sagrid.ac.za/bash-setup.sh
exit 0;
