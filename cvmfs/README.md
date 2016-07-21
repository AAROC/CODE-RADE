# CVMFS README
<!-- TOC depthFrom:undefined depthTo:undefined withLinks:1 updateOnSave:1 orderedList:0 -->

- [CVMFS README](#cvmfs-readme)
	- [Getting CVMFS with Ansible](#getting-cvmfs-with-ansible)
		- [Step-by-step guide](#step-by-step-guide)
	- [Getting CVMFS your damn own self.](#getting-cvmfs-your-damn-own-self)
		- [Using the role stand-alone](#using-the-role-stand-alone)
- [Find the role :](#find-the-role-)
	- [Doing things the hard way](#doing-things-the-hard-way)

<!-- /TOC -->

CODE-RADE uses CVMFS to deliver applications to sites. In order to use the applications, you therefore first need to have CVMFS installed on your site (laptop/cluster/grid/cloud) and properly configured.

> "How am I supposed to do that and what does that even mean ?"

you ask ? Fear not ! We would never leave you in a lurch like that (but we will probably write crappy documentation - sorry :no_mouth:). We provide you with two ways to configure CMVFS clients on the place where you want to execute applications -

  1. The Awesome, Most Perfect, and Idemponently Blissful Ansible Way.
  2. The meh, I'll do it myself way.

## Getting CVMFS with Ansible

The *preferred* way of installing and configuring CVMFS locally is to use our [Ansible](http://www.ansible.com) [playbook](https://github.com/AAROC/DevOps/blob/master/Ansible/cvmfs-client-2.2.yml). See the [DevOps](https://gitub.com/AAROC/DevOps) repo for more information and [Ansible documentation](http://docs.ansible.com/ansible/intro_installation.html) on how to install Ansible.

### Step-by-step guide

The following commands should take you right home :

	1. You're going to need git... duh :
		* **RedHat** : `sudo yum install git`
		* **Debian** : `sudo apt-get install git`
	1. Ensure that you have Ansible :
	   * **RedHat** : `sudo yum install python-pip`
		 * **Debian** : `sudo apt-get install python-pip`
		 * `pip install ansible`
	1. Ensure that you have the DevOps repo install :
		 * `git clone https://github.com/AAROC/DevOps --recursive`
		 * `cd DevOps/Ansible/`
		 * `ansible-playbook -c local -i localhost, cvmfs-client-2.2.yml -s --ask-sudo-pass`

**Note** : The playbook will need some sudo rights since some packages need to be installed and services restarted. We suggest running this playbook as a normal user with sudo rights - hence the `-s` (allow sudo) `--ask-sudo-pass` (and provide the password) Ansible playbook arguments.


## Getting CVMFS your damn own self.

If you don't want to or can't use Ansible, @smasoka has provided a [script](install_cvmfs.sh) to install CVMFS and configure it to mount our repositories. YMMV.

### Using the role stand-alone

If you are _only_ interested in using CODE-RADE, and no other services maintained by the [ROC](http://www.africa-grid.org), you can install the role in a standalone manner, instead of getting it from the AAROC DevOps repo. The role itself is in [Ansible Galaxy](https://galaxy.ansible.com/brucellino/cvmfs_client_2-2/) if you want to avoid using the full DevOps repo, which is quite large. To install the role using Ansible Galaxy, do :

```bash
# Find the role :
ansible-galaxy search cvmfs

Found 2 roles matching your search:

 Name                        Description
 ----                        -----------
 martbhell.cvmfs             Configures a CVMFS client
 brucellino.cvmfs_client_2-2 An Ansile role for configuring CODE-RADE CVMFS repos

```
You want the second one found here  : `brucellino.cvmfs_client_2-2`

Install that to your roles directory :

```bash

ansible-galaxy install brucellino.cvmfs_client_2-2

```

You can use the role in your own playbooks, but YMMV.


## Doing things the hard way

If you think you know better than us and want to configure your own damn CVMFS setup, then by all means, be our guest ! The standard disclaimer applies - we can't help you if you go down that road :smile: - but who knows, you might be right. You'll find the configuration files you need in the [Ansible role](https://github.com/AAROC/DevOps/tree/master/Ansible/roles/cvmfs) we wrote. The repo URL and keys are there, so you should be able to follow the [CVMFS documentation](https://ecsft.cern.ch/dist/cvmfs/cvmfstech-2.1-6.pdf) to set yourself up.



---
