[![Stories in Ready](https://badge.waffle.io/AAROC/CODE-RADE.png?label=ready&title=Ready)](https://waffle.io/AAROC/CODE-RADE)
# Project [CODE-RADE](http://www.africa-grid.org/CODE-RADE)

## Continuous Delivery of Research Applications in a Distributed Environment
<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Project [CODE-RADE](http://www.africa-grid.org/CODE-RADE)](#project-code-radehttpwwwafrica-gridorgcode-rade)
	- [Continuous Delivery of Research Applications in a Distributed Environment](#continuous-delivery-of-research-applications-in-a-distributed-environment)
- [CODE-RADE in 5 seconds :clock12:](#code-rade-in-5-seconds-clock12)
- [CODE-RADE in 5 minutes :clock1:](#code-rade-in-5-minutes-clock1)
	- [Build-Test-Deliver](#build-test-deliver)
		- [Build components :](#build-components-)
		- [Testing components](#testing-components)
		- [Delivery components](#delivery-components)
	- [Using CODE-RADE](#using-code-rade)
- [CODE-RADE in more than 5 minutes.](#code-rade-in-more-than-5-minutes)
	- [Academic projects.](#academic-projects)
	- [EVEN MOAR !](#even-moar-)
- [Delivery](#delivery)
	- [CVMFS](#cvmfs)
	- [Containers](#containers)
- [Collaborating and Contributing](#collaborating-and-contributing)
	- [Project and planning](#project-and-planning)
	- [Improve tests and quality](#improve-tests-and-quality)
	- [Bring your own application](#bring-your-own-application)
	- [Extend the platform](#extend-the-platform)
	- [Extend the target coverage](#extend-the-target-coverage)
- [Roadmap](#roadmap)
	- [Reproducible research](#reproducible-research)
	- [Attribution](#attribution)
	- [Y U NO (brew,conda,easybuild,etc) ?](#y-u-no-brewcondaeasybuildetc-)

<!-- /TOC -->
CODE-RADE solves the problem of reliably, continuously delivering scientific applicaitions to common research computing platforms. Uses Github repos, Jenkins-CI and CVMFS to automatically build, test and deliver your applications to Linux boxes almost everywhere. Grid, Cloud, HPC, your own :computer:, it's all the same to CODE-RADE.

# CODE-RADE in 5 seconds :clock12:

  1. [Install CVMFS](cvmfs/README.md)
  2. Mount our repos
  3. Use our modules
  4. ...
  5. Science !

# CODE-RADE in 5 minutes :clock1:

Curious ? Ok, prepare to have your mind blown :fireworks:...

## Build-Test-Deliver

### Build components :

**CODE-RADE will build your application**

  * :octocat: Use Github to put some code describing how to build an application into a change-controlled repo
	* Every time a commit comes in, we use use Jenkins to build that change
	* Applications focus on their own damn self, dependencies are managed with modules (read why below) and are provided atomically.
	* Build as many combinations of version, toolchain, compiler, optimimsation, etc you like - each artifact gets it's own module


### Testing components

**We build artifacts on for the expected execution environment :**

  * CODE-RADE deploys various _target_ environments as build slaves
  * Typically your average CentOS-6 or Ubuntu-14.04 LTS machine, with grid middleware on them, to make them look like our worker nodes.
  * Assume as little  as possible about the target execution environment - build as many packages as reasonable ourselves.
  * If the build passes, run tests in the simulated environment, as described by the domain expert

No, you can't use Docker. Yet... :soon: Seriously, Foundation Release 3 should have Docker support.

### Delivery components

**Once we're sure that the application will actually run in the target environment, you ship that sucker :ship: !**

  * Use CVMFS to deliver applications
  * Configure application with paths as they will be in the CVMFS repository
  * When tests pass, there is an automated repository transaction
  * Shiny new application is automatically delivered to where you need it, using the magical power of the internet :rainbow: :sparkles:

Even though it sounds like you need to be permanently online for CODE-RADE to work, CVMFS does a good job of caching, so you can happily set up a local cache at a site and consume the apps from there.

## Using CODE-RADE

CODE-RADE builds, tests and deploys user-requested applications using can be used on almost any Linux machine  :

  * on your laptop
  * On your local HPC cluster
  * On your grid site
  * On your cloud site

All you need in each case is access to the repository, via CVMFS. In order to use it you need

  1. CVMFS installed and mount our repos.
  2. A small script to discover the CODE-RADE modules : something like
		```bash
    . /etc/profile.d/modules.sh
		# cvmfs stuff
		export SITE=generic
		export OS=u1404
		export ARCH=x86_64
		export CVMFS_DIR=/cvmfs/fastrepo.sagrid.ac.za/
			# Add modules
		module use $CVMFS_DIR/modules/compilers
		module use $CVMFS_DIR/modules/libraries
		module use ${CVMFS_DIR}/modules/bioinformatics
		module use ${CVMFS_DIR}/modules/astro
		<etc>
	```
	1. `module add <your favourite application>`
	2. What are you waiting for, go SCIENCE ! :tada:

There are examples of how to use the artifacts in the repo in the relevant subdirectories. Get started with [grid examples](grid/example1).


# CODE-RADE in more than 5 minutes.

Are you still here ? Here are some more gory details...

## Academic projects.

CODE-RADE has also been developed in the context of academic projects.  There are several aspects of the platform which need development, so if you would like to propose work, or are interested in undertaking development on the project in the context of postgraduate work at a university, please open an issue and request further information. See [collaborating](#collaborating).

## EVEN MOAR !

Are you one of those [Open Science](http://www.sci-gaia.eu/dakar-declaration) hippies that is all about

  * Reproducibility in research ?
  * Contributorship and attribution of research objects beyond the paper ?
  * Open e-Infrastructures ?
  * Open Access ?

Well, then come on in... Here's what we've got in the [roadmap](#roadmap).

# Delivery

##  CVMFS

Information about how to set up CVMFS mounts can be found in [cvmfs](cvmfs/README.md)

## Containers

Docker containers are used by [Travis](https://travis-ci.org/AAROC/CODE-RADE) to check whether the repo is working. The container Docker files are in [containers](containers)  and you can find them on [Docker Hub](https://hub.docker.com/u/aaroc/dashboard/)

# Collaborating and Contributing

## Project and planning

We use both ZenHub and [Waffle](https://waffle.io/AAROC/CODE-RADE) for providing project boards to developers and colaborators.

CODE-RADE is an open infrastructure project, and aims to reduce the barrier to entry for users of distributed computing infrastructure by solving the delivery problem. The applications you see here come from the work of a few people, and the design of the platform has come from the intellectual contributions of innumerable chats over :beers: and other beverages. For a platform to succeed, it needs to evolve and adapt to the needs of the user community - so if anything you've read here piques your interest, please read [the guidelines on contributing](CONTRIBUTING.md) and let's build something awesome. Essentially, there are a few  general ways to collaborate :

  1. Improve tests and quality
  2. Bring your own application
  3. Extend the platform
  4. Extend the target coverage

## Improve tests and quality

Let's face  it, our documentation sucks. The same could probably be said about the tests we try to run. Only domain experts can really know how to test whether the applications they use are properly built. If you are a domain expert, you can help us to improve the quality of the application in the repository by sending pull requests on the relevant `check-build` script.

## Bring your own application

If you want to work on applications with us, it's probably best to check out [my-first-deploy](https://github.com/SouthAfricaDigitalScience/my-first-deploy) and contents thereof.

## Extend the platform

We **build**, **test**, and **deliver**. All of those can be done better and differently. There are a few design aspects which should not be comprimised - _atomic dependencies_, _continuous integration_, _automation_, _etc. Beyond that, we can talk different ways of building, testing and delivering.

## Extend the target coverage

Do you a computing facility that wants to use CODE-RADE  ? Does it have the funkiest of hardware and special libraries that make applications go vroom  ? Is it the next big thing ? Or, some bohemoth Iron Man style beast from the '90s that everyone has forgetten but is actually the :bomb: ? We don't care ! Cycles is cycles, and we want to run every damn application everywhere.


# Roadmap

## Reproducible research

CODE-RADE provides direct links between the code and method that was used to produce specific scientific results and the results themselves. Each build provides a unique and persistent link to the actual binary that was executed. Each build is linked back via a commit message to a change controlled repository which describes how that binary was built. No hiding from Jenkins !

## Attribution

Some people have harder to blow minds than others. That's ok, we don't judge. Here's some more README stuff - but at this point you're better off reading the [website](http://www.africa-grid.org/CODE-RADE)

## Y U NO (brew,conda,easybuild,etc) ?

CODE RADE solves the delivery problem. We wanted a "fire-and-forget" model, requiring once-off action on the part of a site administrator. In order to do that, it needs to _also_ implement the _build_, _integrate_ and _test_ problems. The latter (ie, everything but the _delivery_ problem) have also been recently solved, and solved well by awesome projects such as :

  * [homebrew](https://github.com/Homebrew/), in particular [homebrew python](https://github.com/Homebrew/homebrew-python) and [homebrew science](https://github.com/Homebrew/homebrew-science/)
  * [conda](http://conda.pydata.org/docs/)
  * [easybuild](http://easybuild.readthedocs.io/en/latest/)
