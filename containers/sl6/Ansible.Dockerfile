# Ansible for CentOS 6.
#
# basic metadata
FROM aaroc/ansiblecontainer
MAINTAINER "Bruce Becker <bbecker@Csir.co.za>"

WORKDIR /root
RUN git clone --recursive https://github.com/AAROC/DevOps/
WORKDIR /root/DevOps/Ansible
RUN ansible-playbook -c local cvmfs-client-2.2.yml
