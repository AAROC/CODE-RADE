# Ansible-enabled for CentOS 6 for CODE-RADE
#
# basic metadata
FROM aaroc/code-rade-sl6-ansible
MAINTAINER "Bruce Becker <bbecker@Csir.co.za>"

# Get the DevOps repo
WORKDIR /root
RUN git clone https://github.com/AAROC/DevOps

WORKDIR DevOps/Ansible
RUN ansible all -i inventories/inventory.local -c local -m ping
RUN ansible-playbook -i inventories/inventory.local -c local cvmfs-client-2.2.yml
