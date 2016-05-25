# Ansible for CentOS 6.
#
# basic metadata
FROM aaroc/ansiblecontainer
MAINTAINER "Bruce Becker <bbecker@Csir.co.za>"

WORKDIR /root
RUN git clone --recursive https://github.com/AAROC/DevOps/
WORKDIR /root/DevOps/Ansible
RUN ansible-playbook -c local cvmfs-static.yml -e slack_token=T02BJKQR4/B03ACH9CV/aSrsbdte1kY4B7taogRVxkWf
