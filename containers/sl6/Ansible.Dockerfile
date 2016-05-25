# Ansible for CentOS 6.
#
# basic metadata
FROM centos:6
MAINTAINER "Bruce Becker <bbecker@Csir.co.za>"

# Get Ansible requirements

RUN  yum -y install \
            python-simplejson \
            libselinux-python \
            git \
            python-setuptools \
            python-devel \
            which
RUN yum -y groupinstall 'Development Tools'

# Install Ansible
WORKDIR /root/
RUN pip install ansible
RUN which ansible
RUN ansible --version
