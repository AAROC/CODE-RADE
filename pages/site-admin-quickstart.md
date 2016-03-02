---
layout: page-fullwidth
meta_title: "Overview of the project"
permalink: /site-admin-quickstart/
header:
  image_fullwidth: sites.jpg
  title: "Site administrator quickstart"
---

Here you can find how to mount the [CVMFS](http://cernvm.cern.ch/portal/filesystem) repositories which deliver our applications to you. Think of CVMFS as a filesystem that you can mount - except a really fast and efficient one !

<!-- TOC depth:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Repository information](#repository-information)
- [Quickstart Guide](#quickstart-guide)
	- [Prerequisites](#prerequisites)
	- [Mounting the repo - private mounts](#mounting-the-repo-private-mounts)
	- [Using our modules](#using-our-modules)
- [Information for site managers](#information-for-site-managers)
	- [Mounting the repo - HPC clusters](#mounting-the-repo-hpc-clusters)
	- [Feedback and suggestions](#feedback-and-suggestions)
- [Footnotes](#footnotes)
<!-- /TOC -->

# Repository information

We currently provide two repositories, which contain *all* of the applications[^communityreposlater] -

<div class="table-responsive">
<table class="table table-condensed table-bordered">
<thead>
<tr class="table table-header">
<td>Repo Name</td><td>Description</td><td>URL</td>
</tr>
</thead>
{% for repo in site.data.cvmfs %}
<tr class="table table-header">
<td>{{ repo.name }}</td><td style="text-align:left">{{ repo.description}}</td><td align="left"><code>{{repo.url}}</code></td>
</tr>
{% endfor %}
</table>
</div>

# Quickstart Guide

If you want to skip ahead to the fun bits, start here. This is a quick summary of the information in [the CVMFS Technical Report](https://ecsft.cern.ch/dist/cvmfs/cvmfstech-2.1-6.pdf) on how to mount repositories.

## Prerequisites

  1. <i class="fa fa-linux"></i> **We only support  Linux - specifically CentOS or Debian.**[^MacOSX]
  1. You need to have the CERN repos in your configuration :
      <i class="fa fa-arrow-right"></i> Install the [CVMFS Release](https://cernvm.cern.ch/portal/downloads) package for your system.
  1. Install the client :
      1. `yum install cvmfs cvmfs-config-default` (RedHat derivatives)
      1. `dpkg -i cvmfs.deb cvmfs-config-default.deb` (Debian and Ubuntu)
  1. [Download the repo keys](https://github.com/AAROC/DevOps/tree/dev/Ansible/roles/cvmfs/files/etc/cvmfs/keys)[^RepoKeys]

## Mounting the repo - private mounts

Mounting the repositories can be done either in "local" or "system"  mode.

  * **System-level** : A mountpoint is defined by the system administrator and is managed by autofs, usually `/cvmfs/<repo-url>`
  * **Local mounts** : A user can make private mounts of a repository by issueing `cvmfs2 -o config=myparams.conf apprepo.sagrid.ac.za <path>`
    * In this case, the minimum content of the `params.conf` file should be something like :
{% highlight bash %}
CVMFS_CACHE_BASE=/home/user/mycache
CVMFS_CLAIM_OWNERSHIP=yes
CVMFS_RELOAD_SOCKETS=/home/user/mycache
CVMFS_SERVER_URL=http://apprepo.sagrid.ac.za/cvmfs/apprepo.sagrid.ac.za
CVMFS_HTTP_PROXY=DIRECT
{% endhighlight %}

The repository will be intelligently cached locally, by simply attempting to access files in it :
{% highlight bash %}
ls /cvmfs/devrepo.sagrid.ac.za/generic/u1404/x86_64/
atlas  cmake  fftw3  gmp  hdf5    mpc   numpy    python            scipy
boost  fftw   gcc    gsl  lapack  mpfr  openmpi  quantum-espresso  zlib
{% endhighlight %}

## Using our modules

We will soon provide bash modules in order to set your environment correctly to use the applications in CVMFS[^ExpectedAugust].

# Information for site managers

<img src="{{ site.url }}/images/ansible_circleA_black_small.svg" height='20px' width='20px'/> Site managers can apply the CVMFS configuration by executing the `cvmfs.yml` playbook in the [AAROC DevOps Repository](https://github.com/AAROC/DevOps)

<i class="fa fa-hand-o-right"></i> Manual configuration is also possible. See the client configuration section of the CVMFS technical report.

## Mounting the repo - HPC clusters

CMVFS is usually controlled by autofs, so if you have autofs on your site, simply add the CVMFS mountpoint to `cvmfs.master` :

{% highlight bash %}
+auto.master
/cvmfs /etc/auto.cvmfs
{% endhighlight %}

<i class="fa fa-lightbulb-o"></i> You can mount the repository on each of the worker nodes indepdendently, or on a local cache, then export it to the worker nodes via NFS.



## Feedback and suggestions

<div class="row">
  <div class="col-md-6">
    <i class="fa fa-exclamation-circle"></i> If you want to report an <span class="text-danger">error</span> please <a href="https://github.com/AAROC/DevOps/issues/new?&labels=CVMFS&title=Problem%20mounting%20CVMFS%20repo">open an issue <i class="fa fa-exclamation-circle"></i></a> </div>
  <div class="col-md-6"><i class="fa fa-comments-o"></i> If you have feedback or suggestions, please start a topic  on the <a href="http://discourse.sci-gaia.eu">forum <i class="fa fa-comments-o   fa-flip-horizontal"></i></a> </div>
  </div>


# Footnotes

[^MacOSX]: If you really want to Mac, check the full technical report on how to do that.
[^communityreposlater]: We can and will happily host community repositories of tested applications later.
[^ExpectedAugust]: We expect this to be finished in mid-August 2015
[^RepoKeys]: The repository keys are necessary to be able to connect to the CVMFS server. We keep ours in github at the moment, in the Ansible role which configures the clients. They are not yet distributed along with cvmf-release package. Someday soon...
