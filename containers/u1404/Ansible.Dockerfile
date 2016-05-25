# Ansible for Ubuntu 1404.
#
# basic metadata
FROM ubuntu:14.04
MAINTAINER "Bruce Becker <bbecker@Csir.co.za>"

# Get Ansible requirements
RUN apt-get update
RUN  apt-get -y install \
     python-simplejson \
     libpython-dev \
     python-selinux \
     git \
     python-setuptools \
     libffi-dev \
     libssl-dev openssl-dev \
     debianutils \
     build-essential

# Install Ansible
RUN pip install paramiko PyYAML Jinja2 httplib2 six
RUN pip install ansible
RUN which ansible
RUN ansible --version

WORKDIR /root
RUN git clone --recursive https://github.com/AAROC/DevOps/
WORKDIR /root/DevOps/Ansible
RUN ansible-playbook -c local -i inventories/inventory.local cvmfs.yml
