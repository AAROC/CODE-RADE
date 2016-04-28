#!/bin/bash -e
# CODE-RADE libsvm basic example
# Author : Bruce Becker
#        : https://github.com/brucellino
#        : CSIR Meraka
# ########################################
# See the README.md in the repo
# Arguments are :
# 1 - CODE-RADE Repo to use (default : fastrepo)
# 2 - Dataset to use (default: 2K)

# This script has 3 parts :
# 1. Set up CODE-RADE apps
# 2. Unpack Staged data
# 3. Process it like a boss

# Arguments are passed in the JDL using the ' Arguments = []; section.
# Important : the arguments are defined by their numerical position :
# Arg1 : Which CODE-RADE repo ?  (default : fastrepo | options : devrepo, apprepo)
# Arg2 : Which data set ? (default 2K | options : 2K, 4K, 6K, 8K, 10K, 12K)
# Arg3-6 : Booleans for what to run
#
# TEST_TRAIN=1/0
# ESTIMATE_C_VALUE=1/0
# FRESH_SETUP=1/0
# PREDICT_STAT=1/0

# ----- What do the parameters mean ? --------
# From @DavidR2016 :
# TEST_TRAIN: Train: trains and outputs a model,
#             Test: tests validation set on the current output model
#             (so it basically trains and tests)
# ESTIMATE_C_VALUE: Estimates the C value which is used for:
#                   The parameter C controls the trade off between errors of the
#                   SVM on training data and margin maximization
# FRESH_SETUP: Gives the experiment a fresh setup every time it runs by removing
#              some of the generated output
# PREDICT_STAT: Prediction of overall statistics showing the accuracy of
#               classification based on the obtained results from
#                training and testing.
# ----------------------------------------------

echo "We are in $PWD"
# ------ What do the exit codes mean ? ---------
# See http://tldp.org/LDP/abs/html/exitcodes.html
# for standard codes (1,2,126,127,128,130,255, etc)
# 3: No arguments set
# 4: Not enough arguments set
# 5: Wrong selection of CODE-RADE  repo
# 6: Wrong selection of Data set
# 7: modules not available
# 8: wierd architecture
# 9: Debian version not supported
# 10: Wierd OS


# We need to run a quick check on the arguments. They have to be at least 2
# If they are less than 2, we die. If they are 2 < NARGS < 6, we only update the
# set ones.

# Set some defaults and allowed variables

# <Set Allowed Mandatory Variables>
ALLOWED_REPOS=("fastrepo" "devrepo" "apprepo")
ALLOWED_DATASETS=("2K" "4K" "6K" "8K" "10K" "12K")
# </Set Alllowed Mandatory Variables>

# <Set Default Optional parameters>
PROCESSING_OPTIONS=(1 0 1 0)
#TEST_TRAIN=1
#ESTIMATE_C_VALUE=0
#FRESH_SETUP=1
#PREDICT_STAT=0
# </Set Default Optional Parameters>

###### <Check on Arguments>#####################################################

#  First, deal with the pathological cases.
#  These are :
# 1. No variables set
# 2. Not enough variables set
# 3. Too many variables set
# 4. Variables set to insane values

# 1. No variables set
# --------------------
if [ "$#" -eq 0 ]; then
  echo "This script requires arguments please :
        Arguments are passed in the JDL using the Arguments = []; section.
        Important : the arguments are defined by their numerical position :
        Arg1   : Mandatory : Which CODE-RADE repo ?  (default : fastrepo | options : devrepo, apprepo)
        Arg2   : Mandatory : Which data set ? (default 2K | options : 2K, 4K, 6K, 8K, 10K, 12K)
        Arg3-6 : Booleans for what to run (optional)
        TEST_TRAIN : 1/0
        ESTIMATE_C_VALUE : 1/0
        FRESH_SETUP :  1/0
        PREDICT_STAT:  1/0

        Go back and try again"
        exit 3;
fi

# 2. not enough variables set
# ---------------------------
if [ "$#" -lt 2 ]; then
  echo "Dude, you have to set at least the first and second arguments of the script"
  echo "\$1 : Repo name (fastrepo/devrepo/apprepo)"
  echo "\$2 : Which data set (2K/4K/6K/8K/10K/12K)"
  echo "Bailing out... go back and try again."
  exit 4;
fi

# 3. Too many variables set
# -------------------------
# IF we have more than 6 arguments, then it's not clear that the user  knows
# what they want to do. We will set the arguments up to and including the last
# one
if [ "$#" -gt 6 ]; then
  echo "your have set too many variables ($# instead of max 6)
  We will use the first 6 to set what we can, but please check your
  settings for sanity."
fi

# 4. Insane variables set
if [[ ! "${ALLOWED_REPOS[*]}" =~ "$1" ]]; then
  echo "Repo $1 not allowed - please use one of ${ALLOWED_REPOS[*]}"
  exit 5;
else
  echo "Setting REPO to $1"
  REPO=$1.sagrid.ac.za
fi
echo "checking datasets"
if [[ ! ${ALLOWED_DATASETS[*]} =~ ${2} ]]; then
  echo "Data Set $2 not allowed - please use one of ${ALLOWED_DATASETS[*]}"
  exit 6;
else
  echo "Setting dataset to ${2}"
  DATASET=$2
fi

if [ "$#" == 2 ]; then
  echo "Running with default parameters : "
  echo "Repo : $1"
  echo "Dataset :$2"
  echo "TEST_TRAIN=1"
  echo "ESTIMATE_C_VALUE=0"
  echo "FRESH_SETUP=1"
  echo "PREDICT_STAT=0"
fi

# 4.1 - Insane variables on processing options"
# for arg_position in $(seq 3 "$#") ; do
#   let "array_position=$arg_position-3"
#   echo "array position is $array_position ; arg_position is $arg_position"
#   if [ "${@:$arg_position:1}" != "1" -a "${@:$arg_position:1}" != "0" ]; then
#     echo "You have set an incorrect value (${@:arg_position:1}) for the argument ${arg_position} "
#     echo "Setting this to the default ${PROCESSING_OPTIONS[$array_position]}"
#   else
#     echo "Setting PROCESSING_OPTIONS[$array_position] to ${@:$arg_position:1}"
#     PROCESSING_OPTIONS[$array_position]=${@:$arg_position:1}
#   fi
# done

# Set the variables that the script uses:
# we could probably do this better with an associative array
# (ie, name/value dict)
# TEST_TRAIN=${PROCESSING_OPTIONS[0]}
# ESTIMATE_C_VALUE=${PROCESSING_OPTIONS[1]}
# FRESH_SETUP=${PROCESSING_OPTIONS[2]}
# PREDICT_STAT=${PROCESSING_OPTIONS[3]}
TEST_TRAIN=1
ESTIMATE_C_VALUE=0
FRESH_SETUP=1
PREDICT_STAT=0

# The data is registered in the MAGrid LFC
start=$(date +%s.%N)
export LFC_HOST=lfc.magrid.ma

######## CODE RADE setup start ################################################
# CODE-RADE needs to determine what SITE, OS and ARCH you are on.
# We need to set the following variables :
# SITE - default = generic
# OS - no default.
# ARCH - default = x86_64
SITE="generic"
OS="undefined"
ARCH="undefined"
CVMFS_DIR="undefined"
#REPO="devrepo.sagrid.ac.za"
#REPO=$1.sagrid.ac.za - this has been set above
shelltype=$(echo "$SHELL" | awk 'BEGIN { FS = "/" } {print $3}')
echo "looks like you're using $shelltype"
# What architecture are we ?
ARCH=$(uname -m)
# It's possible, but very unlikely that some wierdo wants to do this on a machine that's not
# Linux - let's provide for this instance
if [ $? != 0 ] ; then
  echo "My my, uname exited with a nonzero code.  Are you trying to run this from a non-Linux machine ?  Dude ! What's WRONG with you !?  Bailing out... aaaaahhhhhrrrggg...."
  exit 8;
fi

# What OS are we on ?
# Strategy -
# 1. If LSB is present, use that - probably only the case for ubuntu machines
# 2. if not check /etc/debian_version
# 3. If not, check /etc/redhat_release - if there, check the version

# we go in order of likelihood... probably going to be CentOS machines before they're actually
# RH machines.
# TODO : condition for SuSE or Fedora machines. (ok, we don't compile against those yet)

# can haz LSB ?
LSB_PRESENT=$(which lsb_release)
if [ $? != 0 ] ; then
  echo "No LSB found, checking files in /etc/"
  LSB_PRESENT=false
  # probably CEntOS /etc/redhat_release ?
  if [[ -h /etc/redhat-release  &&  -s /etc/centos-release ]] ; then
    echo "We're on a CEntOS machine"
    CENTOS_VERSION=$(rpm -q --queryformat '%{VERSION}' centos-release)
    echo "$CENTOS_VERSION"
    # ok, close enough, we're on sl6
    OS="sl6"
    #  Time to suggest a compiler. Use /proc/version
  fi # We've set OS=sl6 and it's probably a CentOS machine. TODO : test on different machines for false positives.
  # We're probably a debian machine at this point
  if [ -s /etc/debian_release ] ; then
    echo "/etc/debian_release is present - seems to be a debian machine"
  # apparently we don't use this var  IS_DEBIAN=true
    DEBIAN_VERSION=$(awk -F . '{print $1}' /etc/debian_version)
    if [ "${DEBIAN_VERSION}" == 6 ] ; then
      echo "This seems to be Debian 6"
      echo "Setting your OS to u1404 - close enough"
    else
      echo "Debian version ${DEBIAN_VERSION} is not supported"
      exit 9;
    fi
  fi
else # lsb is present
  LSB_ID=$(lsb_release -is)
  LSB_RELEASE=$(lsb_release -rs)
  echo "You seem to be on ${LSB_ID}, version ${LSB_RELEASE}..."
  if [[ "${LSB_ID}" == 'Ubuntu' && "${LSB_RELEASE}" == '14.04' ]] ; then
    echo "Cool, we test this, welcome :) ; Setting OS=u1404"
    OS="u1404"
  elif [[ ${LSB_ID} == 'Ubuntu' ]] ; then
     echo "Dude, you seem to be using an Ubuntu machine, but not the one we test for."
     echo "Setting OS to u1404... YMMV"
     echo "If you want to have this target certified, please request it of the devs "
     echo "by opening a ticket at https://github.com/AAROC/CODE-RADE/issues/new"
     OS="u1404"
  elif [[ ${LSB_ID} == 'CentOS' || ${LSB_ID} == 'Scientific' || ${LSB_ID} == 'REDHAT' ]] ; then
    echo "RPM based machine, now checking the release version"
    if [[ $(echo "$LSB_RELEASE" '>=' 5 |bc) -eq 1 ]] ; then
       echo "We can support your version"
       OS="sl6"
    else
      echo "The minimum release version we support is 6, sorry, please upgrade"
    fi
  else
   echo "Ahem...."
 fi

fi

if [ ${OS} == 'undefined' ] ; then
  echo "damn, OS is still undefined"
  echo "look dude, You're not CentOS , you're not Debian and you don't have LSB... CVMFS is not your problem right now."
  exit 10;
fi


echo "We assuming CVMFS is installed, so we getting the CVMFS mount point"
CVMFS_MOUNT=$(cvmfs_config showconfig "$REPO"|grep CVMFS_MOUNT_DIR|awk -F '=' '{print $2}'|awk -F ' ' '{print $1}')

echo $SITE
echo $OS
echo "$ARCH"
echo "$CVMFS_MOUNT"
echo "$REPO"

export SITE
export OS
export ARCH
export CVMFS_DIR="${CVMFS_MOUNT}/${REPO}"
export REPO
export TMPDIR
echo "you are using ${REPO} version"
cat "/cvmfs/${REPO}/version"
echo "Checking whether you have modules installed"
CODERADE_VERSION=$(cat "/cvmfs/${REPO}/version")
# Is modules even available?
if [ -z "${MODULESHOME}" ] ; then
  echo "MODULESHOME is not set. Are you sure you have modules installed ? you're going to need it."
  echo "stuff in p"
  echo "Exiting"
  exit 7;
else
  source "${MODULESHOME}/init/${shelltype}"
  echo "Great, seems that modules are here, at ${MODULESHOME}"
  echo "Append CVMFS_DIR to the MODULEPATH environment"
  module use "${CVMFS_MOUNT}/${REPO}/modules/libraries"
  module use "${CVMFS_MOUNT}/${REPO}/modules/compilers"
fi

# End of CODE-RADE Setup #######################################################

# checking the environment
module add libsvm/3.14 gnuplot
module list
which svm-predict
which svm-scale
which svm-train
which gnuplot

stagingstart=$(date +%s.%N)

echo "getting the data"
echo "lcg-cp -v --vo sagrid lfn:/grid/sagrid/nwu-hlt/NCHLT/NCHLT_${DATASET}.tar.gz file:${PWD}/NCHLT_${DATASET}.tar.gz"
lcg-cp -v --vo sagrid lfn:/grid/sagrid/nwu-hlt/NCHLT/NCHLT_${DATASET}.tar.gz file:${PWD}/NCHLT_${DATASET}.tar.gz
# Unpack the input data set
tar xfz "NCHLT_${DATASET}.tar.gz" --strip-components=5
stagingend=$(date +%s.%N)

staging_time=$(echo "$stagingend - $stagingstart" | bc)

size=$(du -chs "NCHLT_${DATASET}.tar.gz" | awk '{print $1}' | uniq)
# Tell the team of the staging outcome #################################################
curl -X POST --data-urlencode 'payload={"channel": "#gridjobs", "username": "gridjob", "text": "staging of dataset '"$2"' ('"$size"') on '"$HOSTNAME"' took '"$staging_time"' s. :wave::skin-tone-6:  ", "icon_emoji": ":labtocat:" }' https://hooks.slack.com/services/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
#  #############################################################################


#Radial Basis function Kernel
MAIN_DIR=${PWD} #link to the main directory
SVM_SCRIPTS_DIR=${PWD}
GRID_SEARCH=${SVM_SCRIPTS_DIR} #SCript to run grid search

# PBS_JOBNAME=cream_360534252
# PWD=/home/sagrid019/home_cream_360534252/CREAM360534252
# HOME=/home/sagrid019/home_cream_360534252

ls ${PWD}
echo "perl script is at $(find . -name "*.pl")"
echo "grid.py is at $(find . -name "grid.py")"


curl -X POST --data-urlencode 'payload={"channel": "#gridjobs", "username": "gridjob", "text": "libsvm on '"$HOSTNAME"', starting processing of data set '"$DATASET"' with options '"${PROCESSING_OPTIONS[*]}"' Repo '"$REPO"' '"$CODERADE_VERSION"' ", "icon_emoji": ":labtocat:"}' https://hooks.slack.com/services/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

processing_start=$(date +%s.%N)

for package_name in "original" #"comparing_words" "spell-check"
do
	for size in "${DATASET}" #"4K" #"2K" "4K" "8K" "10K" "12K" # -next step - seralise this.
	do
		LINK=$MAIN_DIR/${package_name}/NCHLT/${size}/SVM_RBF
    echo "LINK is ${LINK}"
		for fold in 1 2 3 4 #1 #2 3 4
		do
			for ngram in 3 #4 5
			do
				NGRAM_LINK=$LINK/fold_${fold}/ngram_${ngram}
        echo "NGRAM_LINK is ${NGRAM_LINK}"
				if [ "$FRESH_SETUP" -eq 1 ]; then
					mkdir -p "$NGRAM_LINK/computation"
					mkdir -p "$NGRAM_LINK/result"

					#Create n-gram tokens
					for lang in "ss" "afr" "zul" "eng"
					do
						LANG_FOLD_DIR=$MAIN_DIR/${package_name}/NCHLT/${size}/cross_validate_${lang}/fold_${fold}
            echo "running the perl script for $lang"
						#Create n-gram tokens across all train set
						perl $SVM_SCRIPTS_DIR/text_normalization.pl $LANG_FOLD_DIR/train_${fold} ${ngram} "" ${lang} 1 0 >> $NGRAM_LINK/computation/all_train_ngrams.txt
					done

					#Sort estracted tokens with their frequency preceeding each token item
					sort $NGRAM_LINK/computation/all_train_ngrams.txt | uniq -c | sed -e 's/^[ ]*//' > $NGRAM_LINK/computation/sorted_all_train_ngrams.txt

					#Create feature vector
					for lang in "ss" "afr" "zul" "eng"
					do
						LANG_FOLD_DIR=$MAIN_DIR/${package_name}/NCHLT/${size}/cross_validate_${lang}/fold_${fold}

						#Create feature vectors used for training and testing
						perl $SVM_SCRIPTS_DIR/text_normalization.pl $LANG_FOLD_DIR/train_${fold} ${ngram} $NGRAM_LINK/computation/sorted_all_train_ngrams.txt ${lang} 0 1 >> $NGRAM_LINK/computation/train.txt

						#Create feature vectors used for testing
						perl ${SVM_SCRIPTS_DIR}/text_normalization.pl $LANG_FOLD_DIR/test_${fold} ${ngram} $NGRAM_LINK/computation/sorted_all_train_ngrams.txt ${lang} 0 1 >> $NGRAM_LINK/computation/test_all.txt

						#Create feature vectors for each languaeg specific data. This will be used to estimate precision and recall per fold.
						perl $SVM_SCRIPTS_DIR/text_normalization.pl $LANG_FOLD_DIR/test_${fold} ${ngram} $NGRAM_LINK/computation/sorted_all_train_ngrams.txt ${lang} 0 1 > $NGRAM_LINK/computation/test_${lang}.txt
					done
          echo "starting svm-scale for the normalised stuff"
					#Create a range values based on the train data and use it to on our test data.
					svm-scale -l 0 -u 1 -s $NGRAM_LINK/computation/range.txt $NGRAM_LINK/computation/train.txt > $NGRAM_LINK/computation/train_norm.txt

					#Apply our range values on test set
          echo "starting svm-scale on all data"
					svm-scale -r $NGRAM_LINK/computation/range.txt $NGRAM_LINK/computation/test_all.txt > $NGRAM_LINK/computation/test_all.data
					for lang in "ss" "afr" "zul" "eng"
					do
            echo "starting svm-scale  on $lang"
						svm-scale -r $NGRAM_LINK/computation/range.txt $NGRAM_LINK/computation/test_${lang}.txt > $NGRAM_LINK/computation/test_${lang}_scale
					done

					#Final data is train.data
					# rl -o $NGRAM_LINK/computation/train.data $NGRAM_LINK/computation/train_norm.txt
          shuf -o $NGRAM_LINK/computation/train.data $NGRAM_LINK/computation/train_norm.txt

					#Remove previous files to free up space
					#rm -f $NGRAM_LINK/computation/train_norm.txt $NGRAM_LINK/computation/train.txt $NGRAM_LINK/computation/sorted_all_train_ngrams.txt $NGRAM_LINK/computation/all_train_ngrams.txt $NGRAM_LINK/computation/test_all.txt
					for lang in "ss" "afr" "zul" "eng"
					do
						rm -f $NGRAM_LINK/computation/test_${lang}.txt
					done
				fi

				if [ $ESTIMATE_C_VALUE -eq 1 ]; then
					count=$(wc -l < "$NGRAM_LINK/computation/sorted_all_train_ngrams.txt")
					one=1
					result=$(echo "$one/$count" | bc -l)
					log=$(echo "l($result)/l(2)" | bc -l)
					cd $GRID_SEARCH
          echo "running the python script"
					python $GRID_SEARCH/grid.py -log2c -13.2877,13.2877,1.6609 -log2g ${log},${log},0 -v 3 -m 300 $NGRAM_LINK/computation/train.data  > $NGRAM_LINK/result/result_${ngram}
					#python $GRID_SEARCH/grid.py -log2c 13.2877,13.2877,0.0 -log2g $log,$log,0 -v 2 -m 400 $NGRAM_LINK/computation/train.data > $NGRAM_LINK/result/result_${ngram}

				fi

				#Train and ouput a model. Test validation set on the output model.
				if [ "$TEST_TRAIN" -eq 1 ]; then
					echo "running training"
          svm-train -c 2 -t 2 -g 0.1767767 -s 0 -m 400 $NGRAM_LINK/computation/train.data $NGRAM_LINK/computation/train.data.model
          echo "running prediction"
					svm-predict $NGRAM_LINK/computation/test_all.data $NGRAM_LINK/computation/train.data.model $NGRAM_LINK/result/predict.txt > $NGRAM_LINK/result/result.txt
				fi

				if [ "$PREDICT_STAT" -eq 1 ]; then
          echo "running prediction of statistics"
					rm -f $NGRAM_LINK/result/statistics.txt $NGRAM_LINK/result/accuracy_for_all_lang

					echo -e " SS  AF  ZUL  EN  TOTAL" >> $NGRAM_LINK/result/statistics.txt

					for lang in "ss" "afr" "zul" "eng"
					do
						echo -e "Identification accuracy for ${lang} is: " >> $NGRAM_LINK/result/accuracy_for_all_lang

						svm-predict $NGRAM_LINK/computation/test_${lang}_scale $NGRAM_LINK/computation/train.data.model $NGRAM_LINK/result/predict_${lang} >> $NGRAM_LINK/result/accuracy_for_all_lang

						$SVM_SCRIPTS_DIR/estimate_total_result.pl $NGRAM_LINK/result/predict_${lang} ${lang} >> $NGRAM_LINK/result/statistics.txt
					done
				fi
			done
		done
	done
done

echo "creating the output sandbox"

end=$(date +%s.%N)
processing_time=$(echo "$end - $processing_start" | bc)
total_time=$(echo "$end - $start" | bc)

# TODO
# Get the Processor info from lcg-info


# Add the output to the collection
# the basic workflow is :
# 1. get a token (username and password are required)
# 2. register the data in the catalogue
# 3. Update the average ?

# 1. Get the token
# curl POST /v2/users/login HTTP/1.1 {'username': 'brucellino', 'password': '<password>'}
curl -X POST -H 'Content-Type: application/json' -d '{"username": "brucellino","password": "EQXIovD0tId4JqV4_CWGNHEzF9HYA4nk"}' http://glibrary.ct.infn.it:3500/v2/users/login > auth
export token=$(python -c 'import json,sys; json_data=open("auth"); data=json.load(json_data); print data["id"]')

# 2. Register the data
# curl POST /v2/repos/nwu-hlt/nchlt HTTP/1.1
curl -X POST -H "Content-Type: application/json" -H "Authorization: $token" -d '{"dataset": "'"$DATASET"'", "total_time": "'"$total_time"'", "staging_time": "'"$staging_time"'", "processing_time": "'"$processing_time"'"}' http://glibrary.ct.infn.it:3500/v2/repos/nwu_hlt/nchlt

# 3. Calculate the average
#

# Tell the team of the outcome #################################################
# First, get the X509 subject of the submitter
submitter=$(openssl x509 -in "$X509_USER_PROXY" -noout -subject | awk  'BEGIN { FS = "/" } {print $6}') # Common Name
institute=$(openssl x509 -in "$X509_USER_PROXY" -noout -subject | awk  'BEGIN { FS = "/" } {print $6}') # L= (institute)
# Send slack message
curl -X POST --data-urlencode 'payload={"channel": "#gridjobs","username": "gridjob", "text": "Libsvm processing of '"$DATASET"' on '"$HOSTNAME"' took '"$processing_time"' s. :wave::skin-tone-6:", "icon_emoji": ":labtocat:", "attachments": [ { "fallback": "Job info.", "color": "#36a64f", "pretext": "Job information summary", "title": "Job information", "text": "Submitted by '"$submitter"' from '"$institute"'", "fields": [ { "title": "Total Job Time", "value": "'"$total_time"'", "short": true }, {"title": "Total Processing Time", "value": "'"$processing_time"'", "short": true }, { "title": "Data Staging Time", "value": "'"$staging_time"'", "short": true } ] } ] }' https://hooks.slack.com/services/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
#  #############################################################################
