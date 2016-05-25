# Ansible for Ubuntu 1404.
#
# basic metadata
FROM aaroc/ansiblecontainer-u1404
MAINTAINER "Bruce Becker <bbecker@Csir.co.za>"

# Get Ansible requirements

WORKDIR /root
RUN git clone --recursive https://github.com/AAROC/DevOps/
WORKDIR /root/DevOps/Ansible
RUN ansible-playbook -c local -i inventories/inventory.local cvmfs-static.yml -e slack_token=T02BJKQR4/B03ACH9CV/aSrsbdte1kY4B7taogRVxkWf
