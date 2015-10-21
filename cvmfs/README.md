# CVMFS README
<!-- TOC depth:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [CVMFS README](#cvmfs-readme)
	- [Getting CVMFS with Ansible](#getting-cvmfs-with-ansible)
	- [Getting CVMFS your own self.](#getting-cvmfs-your-own-self)
	- [Doing things the hard way](#doing-things-the-hard-way)
<!-- /TOC -->
CODE-RADE uses CVMFS to deliver applications to sites. In order to use the applications, you therefore first need to have CVMFS installed on your site (laptop/cluster/grid/cloud) and properly configured.

"How am I supposed to do that and what doe that even mean ?", you ask ?

Fear not ! We would never leave you in a lurch like that.

## Getting CVMFS with Ansible

The *preferred* way of installing and configuring CVMFS locally is to use our [Ansible](http://www.ansible.com) [playbook](https://github.com/AAROC/DevOps/blob/master/Ansible/cvmfs.yml). See the [DevOps](https://gitub.com/AAROC/DevOps) repo for more information and [Ansible documentation](http://docs.ansible.com/ansible/intro_installation.html) on how to install Ansible.

## Getting CVMFS your own self.

If you don't want to or can't use Ansible, @smasoka has provided a [script](install_cvmfs.sh) to install CVMFS and configure it to mount our repositories. YMMV.

## Doing things the hard way

If you think you know better than us and want to configure your own damn CVMFS setup, then by all means, be our guest ! The standard disclaimer applies - we can't help you if you go down that road :smile: - but who knows, you might be right. You'll find the configuration files you need in the [Ansible role](https://github.com/AAROC/DevOps/tree/master/Ansible/roles/cvmfs) we wrote. The repo URL and keys are there, so you should be able to follow the [CVMFS documentation](https://ecsft.cern.ch/dist/cvmfs/cvmfstech-2.1-6.pdf) to set yourself up.
