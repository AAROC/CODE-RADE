# Ansible for CentOS 6.
#
# basic metadata
FROM centos:6.7
MAINTAINER "Bruce Becker <bbecker@Csir.co.za>"

# Get Ansible requirements

RUN  yum -y install python-simplejson libselinux-python git pip

# Install Ansible
WORKDIR /root/
RUN git clone --recursive https://github.com/ansible/ansible
WORKDIR ansible
RUN pip install setuptools
RUN python setup.py install
RUN which ansible
RUN ansible --version
