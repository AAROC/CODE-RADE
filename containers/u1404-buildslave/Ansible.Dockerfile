# Ansible for Ubuntu 1404.
#
# basic metadata
FROM ubuntu:14.04
MAINTAINER "Bruce Becker <bbecker@Csir.co.za>"

# Get Ansible requirements

RUN  apt-get -y install \
     python-simplejson \
     python-selinux  \
     git \
     python-setuptools \
     debianutils \
     build-essential

# Install Ansible
WORKDIR /root
RUN git clone --recursive https://github.com/ansible/ansible
WORKDIR ansible
RUN pip install setuptools
RUN python setup.py install
RUN which ansible
RUN ansible --version
