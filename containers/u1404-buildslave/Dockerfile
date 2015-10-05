# Ubuntu build slave container for CODE-RADE

# basic metadata
MAINTAINER Bruce Becker <bbecker@Csir.co.za>
FROM ansible/ubuntu14.04-ansible

# get AAROC DevOps code

CMD git clone https://github.com/AAROC/DevOps
WORKDIR DevOps/Ansible
CMD ansible -c local cvmfs.yml
