# CODE-RADE Example 1 - Version Check

This is the README for CODE-RADE grid example 1. This example simply checks the version of `fastrepo.sagrid.ac.za` which is available on the site.

This example consists of

  1. 1 shell script - `example1.sh`
  2. 1 JDL file - `example1.jdl`

# Step-by-step instructions

  1. Get a proxy :
     * Command :
           voms-proxy-init --voms sagrid
     * Expected Output :
            Your identity: /C=IT/O=INFN/OU=Personal Certificate/L=ZA-MERAKA/CN=Bruce Becker
            Creating temporary proxy .................................................
            Done
            Contacting  voms.sagrid.ac.za:15001 [/C=IT/O=INFN/OU=Host/L=ZA-UFS/CN=voms.sagrid.ac.za] "sagrid" Done
            Creating proxy ......................................................
            Done
            Your proxy is valid until Thu Mar  3 06:32:12 2016

  1. Check job matches
