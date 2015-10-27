#!/bin/bash -ex
#CVMFS installation script. 
#'sudo sh install_cvmfs.sh' - To run it
# NOTE: It is preferable to use the Ansible playbook in https://github.com/AAROC/DevOps/

WORK_DIR=`pwd`
SOURCE="https://ecsft.cern.ch/dist/cvmfs/cvmfs-2.1.20/cvmfs-2.1.20.tar.gz"
WORKSPACE="/tmp/cvmfs-2.1.20"
CVMFS_CONFIG_DIR="/etc/cvmfs/"
CVMFS_REPO_DIR="/cvmfs/apprepo.sagrid.ac.za"

grep cvmfs /etc/passwd
if [ $? -eq 0 ] ; then
	echo "cvmfs user exists"
else
	echo "cvmfs user doesn't exist, so we creating him"
	useradd -r -s /bin/false cvmfs
	echo "Add user to Fuse Group"
	usermod -G fuse cvmfs
fi

echo "create cvmfs mount dir"
mkdir /cvmfs

echo "configure auto.master"
echo "/cvmfs /etc/auto.cvmfs" >> /etc/auto.master

echo "Download the tar"
#wget ${SOURCE} -O ${WORKSPACE}.tar.gz

echo "unpacking the source"
tar -zxvf ${WORKSPACE}.tar.gz -C /tmp/

echo "Make build dir"
mkdir -p ${WORKSPACE}/build
cd ${WORKSPACE}/build

echo "Run cmake"
cmake ../

echo "Run make"
make 

echo "Run: sudo make install"
make install

echo "Copy config files"
echo "$WORK_DIR"
cp -r $WORK_DIR/config/* $CVMFS_CONFIG_DIR
ls $CVMFS_CONFIG_DIR

echo "Restart nfs"
service autofs restart

echo "sleep 5 seconds"
sleep 5

echo "Check repo mount"
ls $CVMFS_REPO_DIR
if [ $? -eq 0 ] ; then
	echo "$CVMFS_REPO_DIR is mounted" 
else
	echo "$CVMFS_REPO_DIR is not mounted. There was an error"
fi
