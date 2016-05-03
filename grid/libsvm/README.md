# LibSVM README

This is the README for the grid examples of [libsvm](http://ci.sagrid.ac.za/job/libsvm-deploy)

This directory contains the following exammples:

  * Example 1 : basic submission of a job to use libsvm
  * RBF Example : Runs a whole bunch of stuff, including some python stuff.

# Studies

A short study was conducted for the following parameter space:

  * single ngram (3-gram)
  * 4 folds
  * On each site of (ZA-UJ and ZA-WITS)
  * for each dataset of (2K, 6K)

Only C-parameter estimation performed.

These are defined in the JDLs :

  1. `study1.jdl` : 3-gram, 4 fold, 2K dataset, site=ZA-UJ
  1. `study2.jdl` : 3-gram, 4 fold, 6K dataset, site=ZA-UJ
  1. `study3.jdl` : 3-gram, 4 fold, 2K dataset, site=ZA-WITS-CORE
  1. `study4.jdl` : 3-gram, 4 fold, 6K dataset, site=ZA-WITS-CORE
