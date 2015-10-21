# Ansible for Ubuntu 1404.
#
# basic metadata
FROM ubuntu:14.04
MAINTAINER "Bruce Becker <bbecker@Csir.co.za>"

# Get Ansible requirements

CMD  apt-get install \
     python-simplejson \
     libselinux-python \
     git

# Install Ansible
