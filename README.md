# [CODE-RADE](http://www.africa-grid.org/CODE-RADE)

## Project CODE-RADE : Continuous Delivery of Research Applications in a Distributed Environment

Uses Github repos, Jenkins-CI and CVMFS to build, test and deliver your applications to Linux boxes almost everywhere.


<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [CODE-RADE - http://www.africa-grid.org/CODE-RADE](#code-rade-httpwwwafrica-gridorgcode-rade)
- [Project](#project)
	- [Academic projects](#academic-projects)
	- [Using](#using)
	- [CVMFS](#cvmfs)
	- [Containers](#containers)
	- [Collaborating](#collaborating)

<!-- /TOC -->

# Project

[![tickets in Backlog](https://badge.waffle.io/AAROC/CODE-RADE.svg?label=backlog&title=backlog)](https://waffle.io/AAROC/CODE-RADE) [![tickets in Ready](https://badge.waffle.io/AAROC/CODE-RADE.svg?label=ready&title=Ready)](https://waffle.io/AAROC/CODE-RADE) [![issues in Ready](https://badge.waffle.io/AAROC/CODE-RADE.svg?label=in%20progress&title=In%20Progress)](https://waffle.io/AAROC/CODE-RADE) [![issues in Ready](https://badge.waffle.io/AAROC/CODE-RADE.svg?label=passing&title=Passing)](https://waffle.io/AAROC/CODE-RADE) [![issues in Ready](https://badge.waffle.io/AAROC/CODE-RADE.svg?label=delivery&title=Delivery)](https://waffle.io/AAROC/CODE-RADE) [![Build Status](https://travis-ci.org/AAROC/CODE-RADE.svg?branch=u1404-buildslave)](https://travis-ci.org/AAROC/CODE-RADE)

## What is CODE-RADE for ?

CODE-RADE solves the problem of application delivery to back-end computing infrastructure. 

CODE-RADE is an Open community project which anyone can use or contribute to.
<!-- TODO - add CONTRIBUTING and CODE_OF_CONDUCT -->


## Academic projects.

CODE-RADE has also been developed in the context of academic projects (Hons). There are several aspects of the platform which need development, so if you would like to propose work, or are interested in undertaking development on the project in the context of postgraduate work at a university, please open an issue and request further information. See [collaborating](#collaborating)

## Using

CODE-RADE builds, tests and deploys user-requested applications using can be used on almost any Linux machine  :

  * on your laptop
  * On your local HPC cluster
  * On your grid site
  * On your cloud site

There are examples of how to use the artifacts in the repo in the relevant subdirectories

##  CVMFS

Information about how to set up CVMFS mounts can be found in [cvmfs](cvmfs/README.md)

## Containers

Docker containers are used by [Travis](https://travis-ci.org/AAROC/CODE-RADE) to check whether the repo is working. The container Docker files are in [containers](containers)  and you can find them on [Docker Hub](https://hub.docker.com/u/aaroc/dashboard/)


## Collaborating

If you want to work on applications with us, it's probably best to check out [my-first-deploy](https://github.com/SouthAfricaDigitalScience/my-first-deploy) and contents thereof.
