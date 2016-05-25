# Ansible for CentOS 6.
#
# basic metadata
FROM centos:6
MAINTAINER "Bruce Becker <bbecker@Csir.co.za>"

# Get Ansible requirements
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum update
RUN  yum -y install \
            python-simplejson \
            libselinux-python \
            python-setuptools \
            python-devel \
            python-pip \
            libffi-devel \
            libssl-devel openssl-devel \
            which \
            git
RUN yum -y groupinstall 'Development Tools'

# Install Ansible
RUN pip install paramiko PyYAML Jinja2 httplib2 six
RUN pip install ansible
RUN which ansible
RUN ansible --version

WORKDIR /root
RUN git checkout --recursive https://github.com/AAROC/DevOps/
WORKDIR /root/DevOps/Ansible
RUN ansible-playbook -c local -i inventories/inventory.local cvmfs.yml
