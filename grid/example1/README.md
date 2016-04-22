# CODE-RADE Example 1 - Version Check

This is the README for CODE-RADE grid example 1. This example simply checks the version of `fastrepo.sagrid.ac.za` which is available on the site. The script also checks what is in the mapped user's environment.

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

  1. Check job matches :
    * Command :
          glite-wms-job-list-match -a example1.jdl
    * Expected Output :
           Connecting to the service https://wms.c4.csir.co.za:7443/glite_wms_wmproxy_server

           ==========================================================================

		                          COMPUTING ELEMENT IDs LIST
           The following CE(s) matching your job requirements have been found:

	         *CEId*
           - cream-ce.core.wits.ac.za:8443/cream-pbs-sagrid
           - glite-ce.grid.uj.ac.za:8443/cream-pbs-sagrid
           - grid-ce.chpc.ac.za:8443/cream-pbs-sagrid
           - gridsrv2-4.dir.garr.it:8443/cream-pbs-grid
           - srvslngrd007.uct.ac.za:8443/cream-pbs-sagrid

           ==========================================================================
  1. Submit a job :
    1. Submission with automatic proxy delegation and selection of endpoint :
      * Command :
              glite-wms-job-submit -a -o example1.jobid example1.jdl
      * Expected Output :
              ====================== glite-wms-job-submit Success ======================
              The job has been successfully submitted to the WMProxy
              Your job identifier is:
              https://wms.c4.csir.co.za:9000/4bffUoNCtvL7q2KRptJSFA
              The job identifier has been saved in the following file:
              example1.jobid
              ==========================================================================
  1. Check job status :
    * Command :
            glite-wms-job-status -i example1.jobid
    * Expected Output
            ======================= glite-wms-job-status Success =====================
            BOOKKEEPING INFORMATION:
            Status info for the Job : https://wms.c4.csir.co.za:9000/4bffUoNCtvL7q2KRptJSFA
            Current Status:     Running
            Status Reason:      unavailable
            Destination:        glite-ce.grid.uj.ac.za:8443/cream-pbs-sagrid
            Submitted:          Wed Mar  2 19:07:36 2016 SAST
            ==========================================================================
  1. Get the output :
    * Command :
            glite-wms-job-output -i example1.jobid
    * Expected Output :
            Connecting to the service https://wms.c4.csir.co.za:7443/glite_wms_wmproxy_server
            ================================================================================
            			JOB GET OUTPUT OUTCOME
            Output sandbox files for the job:
            https://wms.c4.csir.co.za:9000/4bffUoNCtvL7q2KRptJSFA
            have been successfully retrieved and stored in the directory:
            /tmp/jobOutput/becker_4bffUoNCtvL7q2KRptJSFA
            ================================================================================
  1. Check the output :
    * Command :
            tail -n2  /tmp/jobOutput/becker_4bffUoNCtvL7q2KRptJSFA/tmp/jobOutput/becker_4bffUoNCtvL7q2KRptJSFA/example1.out
    * Expected Output :
            FastRepo version is
            Build 138
