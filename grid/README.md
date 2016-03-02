# README for grid job submission using CODE-RADE

# Overview

This file is for job submission to grid infrastructures using CODE-RADE. The directory contains some sample JDL and scripts which could be used to execute applications in the repository

# <em>Caveat Lector</em>

Note that this documentation and these examples may refer to specific Virtual Organisations and configurations at sites.

  * This has been written for the `sagrid` VO.
  * This describes job submission via the gLite (WMS and CREAM) CLI

# Prerequisites

## Authentication and Authorisation

There are a few basic prerequisites to run jobs on the grid using the CLI

  1. Have a personal X.509 certificate from a trusted [CA](#GetCert)
  2. Belong to a supported [Virtual Organisation](#VOSagrid)
  3. Have a user account on one of the [User Interfaces](#RequestUI)

## Job Description Language and Job Management

  * You should be familiar with the basic commands of job submission and the [Job Description Language](https://wiki.italiangrid.it/twiki/bin/view/CREAM/JdlGuide).
  * You should be able to read and understand shell scripts

You should be able to submit *generic* jobs which execute arbitrary scripts.

# Submitting jobs to use CODE-RADE

## Example 1 - Basic check

The first example will demonstrate how to check the version of CODE-RADE that is available on a site. This can be found in [example1](example1/)


# Footnotes and References

  * <a name="GetCert"></a> See [the EUGridPMA](http://www.eugridpma.org) website to find out who you can request a certificate from.
  * <a name="VOSagrid"></a> We will be using `sagrid` VO as example here. You can check if you belong to a VO by going to the VOMS server with the certificate in your browser
  * <a name="RequestUI"></a> You can request an account via the [SAGrid Perun instance](https://perun.c4.csir.co.za/non/register)
