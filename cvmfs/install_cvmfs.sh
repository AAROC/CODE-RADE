#!/bin/bash -e
#CVMFS installation script. 
#'sudo sh install_cvmfs.sh' - To run it

WORK_DIR=`pwd`
SOURCE_REPO="http://cvmrepo.web.cern.ch/cvmrepo/yum/cernvm.repo"
YUM_REPO="/etc/yum.repos.d/cernvm.repo"
GPG_KEY="http://cvmrepo.web.cern.ch/cvmrepo/yum/RPM-GPG-KEY-CernVM"
GPG_DIR="/etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM"
packages="cvmfs-release cvmfs-keys cvmfs cvmfs-init-scripts cvmfs-auto-setup"
CVMFS_CONFIG_DIR="/etc/cvmfs/"
CVMFS_REPO_DIR="/cvmfs/apprepo.sagrid.ac.za"

echo "Downloading Repo to yum.repos.d and GPG key"
wget $SOURCE_REPO -O $YUM_REPO
wget $GPG_KEY -O $GPG_DIR

echo "Check the repo download"
ls $YUM_REPO
if [ $? -ne 0 ] ; then
	echo "$YUM_REPO is not downloaded or configured"
fi

echo "Install the client packages" $packages
yum -y install $packages

echo "Copy config files"
echo "$WORK_DIR"
cp -r $WORK_DIR/config/* $CVMFS_CONFIG_DIR
ls $CVMFS_CONFIG_DIR

echo "Restart nfs"
service autofs restart

echo "Check repo mount"
ls $CVMFS_REPO_DIR
if [ $? -eq 0 ] ; then
	echo "$CVMFS_REPO_DIR is mounted" 
else
	echo "$CVMFS_REPO_DIR is not mounted. There was an error"
fi
