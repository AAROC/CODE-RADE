# LibSVM README

This is the README for the grid examples of [libsvm](http://ci.sagrid.ac.za/job/libsvm-deploy)

This directory contains the following exammples:

  * Example 1 : basic submission of a job to use libsvm
  * RBF Example : Runs a whole bunch of stuff, including some python stuff.

# Studies

## Baseline studies

A set short studies were conducted in order to determine a baseline, for the following parameter space:

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
  1. 'study5.jdl' : 3-gram, 4 fold, 12K dataset, site=ZA-UJ
  1. 'study6.jdl' : 3-gram, 4 fold, 2K dataset, site=CHPC, machine gnode-2-32.chpc.ac.za
  1. 'study7.jdl' : 3-gram, 4 fold, 6K dataset, site=CHPC, machine gnode-2-32.chpc.ac.za
  1. 'study8.jdl' : 3-gram, 4 fold, 12K dataset, site=CHPC, machine gnode-2-32.chpc.ac.za

## Parallel C-estimation and Training

The python script that performs C-parameter estimation and training has been implemented with a queue system, which can take advantage of several available cores.
In order to estimate the scaling efficiency and investigate higher performance, we conduct a few studies to vary the available cores

  1. `study1-par-2.jdl` : 3-gram, 4 fold, 2K dataset, site=ZA-UJ, 2 Cores
  2. `study1-par-4.jdl` : 3-gram, 4 fold, 2K dataset, site=ZA-UJ, 4 Cores
  3. `study1-par-8.jdl` : 3-gram, 4 fold, 2K dataset, site=ZA-UJ, 8 Cores
  4. `study2-par-2.jdl` : 3-gram, 4 fold, 6K dataset, site=ZA-UJ, 2 Cores
  5. `study2-par-4.jdl` : 3-gram, 4 fold, 6K dataset, site=ZA-UJ, 4 Cores
  6. `study2-par-8.jdl` : 3-gram, 4 fold, 6K dataset, site=ZA-UJ, 8 Cores
  7. `study3-par-2.jdl` : 3-gram, 4 fold, 2K dataset, site=ZA-WITS-CORE, 2 Cores
  8. `study3-par-4.jdl` : 3-gram, 4 fold, 2K dataset, site=ZA-WITS-CORE, 4 Cores
  9. `study3-par-8.jdl` : 3-gram, 4 fold, 2K dataset, site=ZA-WITS-CORE, 8 Cores
  10. `study4-par-2.jdl` : 3-gram, 4 fold, 6K dataset, site=ZA-WITS-CORE, 2 Cores
  11. `study4-par-4.jdl` : 3-gram, 4 fold, 6K dataset, site=ZA-WITS-CORE, 4 Cores
  12. `study4-par-8.jdl` : 3-gram, 4 fold, 6K dataset, site=ZA-WITS-CORE, 8 Cores
  13. `study5-par-8.jdl` : 3-gram, 4 fold, 12K dataset, site=ZA-UJ, 8 Cores
  14. `study6-par-48.jdl` : 3-gram, 4 fold, 2K dataset, site=CHPC, machine gnode-2-32.chpc.ac.za, 48 Cores
  15. `study7-par-48.jdl` : 3-gram, 4 fold, 6K dataset, site=CHPC, machine gnode-2-32.chpc.ac.za, 48 Cores
  16. `study8-par-48.jdl` : 3-gram, 4 fold, 12K dataset, site=CHPC, machine gnode-2-32.chpc.ac.za, 48 Cores
