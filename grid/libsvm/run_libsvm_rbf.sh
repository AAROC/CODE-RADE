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

# The data is registered in the MAGrid LFC
start=`date +%s.%N`
export LFC_HOST=lfc.magrid.ma
env 
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
REPO=$1.sagrid.ac.za
shelltype=`echo $SHELL | awk 'BEGIN { FS = "/" } {print $3}'`
echo "looks like you're using $shelltype"
# What architecture are we ?
ARCH=`uname -m`
# It's possible, but very unlikely that some wierdo wants to do this on a machine that's not
# Linux - let's provide for this instance
if [ $? != 0 ] ; then
  echo "My my, uname exited with a nonzero code. \n Are you trying to run this from a non-Linux machine ? \n Dude ! What's WRONG with you !? \n\n Bailing out... aaaaahhhhhrrrggg...."
  exit 127
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
LSB_PRESENT=`which lsb_release`
if [ $? != 0 ] ; then
  echo "No LSB found, checking files in /etc/"
  LSB_PRESENT=false
  # probably CEntOS /etc/redhat_release ?
  if [[ -h /etc/redhat-release  &&  -s /etc/centos-release ]] ; then
    echo "We're on a CEntOS machine"
    CENTOS_VERSION=`rpm -q --queryformat '%{VERSION}' centos-release`
    echo $CENTOS_VERSION
    # ok, close enough, we're on sl6
    OS="sl6"
    #  Time to suggest a compiler. Use /proc/version
  fi # We've set OS=sl6 and it's probably a CentOS machine. TODO : test on different machines for false positives.
  # We're probably a debian machine at this point
  if [ -s /etc/debian_release ] ; then
    echo "/etc/debian_release is present - seems to be a debian machine"
    IS_DEBIAN=true
    DEBIAN_VERSION=`cat /etc/debian_version | awk -F . '{print $1}'`
    if [ ${DEBIAN_VERSION} == 6 ] ; then
      echo "This seems to be Debian 6"
      echo "Setting your OS to u1404 - close enough"
    else
      echo "Debian version ${DEBIAN_VERSION} is not supported"
      exit 127
    fi
  fi
else # lsb is present
  LSB_ID=`lsb_release -is`
  LSB_RELEASE=`lsb_release -rs`
  echo "You seem to be on ${LSB_ID}, version ${LSB_RELEASE}..."
  if [[ ${LSB_ID} == 'Ubuntu' && ${LSB_RELEASE} == '14.04' ]] ; then
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
    if [[ $(echo $LSB_RELEASE '>=' 6 |bc) -eq 1 ]] ; then
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
  exit 127
fi


echo "We assuming CVMFS is installed, so we getting the CVMFS mount point"
CVMFS_MOUNT=`cvmfs_config showconfig $REPO|grep CVMFS_MOUNT_DIR|awk -F '=' '{print $2}'|awk -F ' ' '{print $1}'`

echo $SITE
echo $OS
echo $ARCH
echo $CVMFS_MOUNT
echo $REPO

export SITE
export OS
export ARCH
export CVMFS_DIR=${CVMFS_MOUNT}/${REPO}
export REPO
export TMPDIR
echo "you are using ${REPO} version"
cat /cvmfs/${REPO}/version
echo "Checking whether you have modules installed"
CODERADE_VERSION=`cat /cvmfs/${REPO}/version`
# Is "modules even available? "
if [ -z ${MODULESHOME} ] ; then
  echo "MODULESHOME is not set. Are you sure you have modules installed ? you're going to need it."
  echo "stuff in p"
  echo "Exiting"
  exit 1;
else
  source ${MODULESHOME}/init/${shelltype}
  echo "Great, seems that modules are here, at ${MODULESHOME}"
  echo "Append CVMFS_DIR to the MODULEPATH environment"
  module use ${CVMFS_MOUNT}/${REPO}/modules/libraries
  module use ${CVMFS_MOUNT}/${REPO}/modules/compilers
fi

# End of CODE-RADE Setup #######################################################

# checking the environment
module add libsvm gnuplot
module list
which svm-predict
which svm-scale
which svm-train
which gnuplot

stagingstart=`date +%s.%N`

echo "getting the data"
lcg-cp -v --vo sagrid lfn:/grid/sagrid/nwu-hlt/NCHLT/NCHLT_${2}.tar.gz file:${PWD}/NCHLT_${2}.tar.gz
# Unpack the input data set
tar xfz NCHLT_${2}.tar.gz --strip-components=5
stagingend=`date +%s.%N`
stagingtime=`echo "$stagingend - $stagingstart" | bc`

size=`du -chs NCHLT_${2}.tar.gz | awk '{print $1}' | uniq`
# Tell the team of the staging outcome #################################################
curl -X POST --data-urlencode 'payload={"channel": "#gridjobs", "username": "gridjob", "text": "staging of dataset '"$2"' ('"$size"') on '"$HOSTNAME"' took '"$stagingtime"' s. :wave::skin-tone-6:  ", "icon_emoji": ":labtocat:" }' https://hooks.slack.com/services/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
#  #############################################################################


#Radial Basis function Kernel
MAIN_DIR=${HOME} #link to the main directory
SVM_SCRIPTS_DIR=${HOME}
GRID_SEARCH=${SVM_SCRIPTS_DIR} #SCript to run grid search

ls ${HOME}
echo "perl script is at "
find . -name "*.pl"

echo "grid.py is at "
find . -name "grid.py"

TEST_TRAIN=0
ESTIMATE_C_VALUE=1
FRESH_SETUP=1
PREDICT_STAT=0
curl -X POST --data-urlencode 'payload={"channel": "#gridjobs", "username": "gridjob", "text": "libsvm on '"$HOSTNAME"', starting processing of data set '"$2"' with Repo '"$1"' '"$CODERADE_VERSION"' ", "icon_emoji": ":labtocat:"}' https://hooks.slack.com/services/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

for package_name in "original" #"comparing_words" "spell-check"
do
	for size in "2K" #"4K" #"2K" "4K" "8K" "10K" "12K"
	do
		LINK=$MAIN_DIR/${package_name}/NCHLT/${size}/SVM_RBF

		for fold in 1 2 3 4 #1 #2 3 4
		do
			for ngram in 3 #4 5
			do
				NGRAM_LINK=$LINK/fold_${fold}/ngram_${ngram}

				if [ $FRESH_SETUP -eq 1 ]; then
					rm -r -f $NGRAM_LINK

					mkdir -p $NGRAM_LINK/computation
					mkdir -p $NGRAM_LINK/result

					#Create n-gram tokens
					for lang in "ss" "afr" "zul" "eng"
					do
						LANG_FOLD_DIR=$MAIN_DIR/${package_name}/NCHLT/${size}/cross_validate_${lang}/fold_${fold}

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
						perl $SVM_SCRIPTS_DIR/text_normalization.pl $LANG_FOLD_DIR/test_${fold} ${ngram} $NGRAM_LINK/computation/sorted_all_train_ngrams.txt ${lang} 0 1 >> $NGRAM_LINK/computation/test_all.txt

						#Create feature vectors for each languaeg specific data. This will be used to estimate precision and recall per fold.
						perl $SVM_SCRIPTS_DIR/text_normalization.pl $LANG_FOLD_DIR/test_${fold} ${ngram} $NGRAM_LINK/computation/sorted_all_train_ngrams.txt ${lang} 0 1 > $NGRAM_LINK/computation/test_${lang}.txt
					done

					#Create a range values based on the train data and use it to on our test data.
					svm-scale -l 0 -u 1 -s $NGRAM_LINK/computation/range.txt $NGRAM_LINK/computation/train.txt > $NGRAM_LINK/computation/train_norm.txt

					#Apply our range values on test set
					svm-scale -r $NGRAM_LINK/computation/range.txt $NGRAM_LINK/computation/test_all.txt > $NGRAM_LINK/computation/test_all.data
					for lang in "ss" "afr" "zul" "eng"
					do
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
					python $GRID_SEARCH/grid.py -log2c -13.2877,13.2877,1.6609 -log2g ${log},${log},0 -v 3 -m 300 $NGRAM_LINK/computation/train.data  > $NGRAM_LINK/result/result_${ngram}
					#python $GRID_SEARCH/grid.py -log2c 13.2877,13.2877,0.0 -log2g $log,$log,0 -v 2 -m 400 $NGRAM_LINK/computation/train.data > $NGRAM_LINK/result/result_${ngram}

				fi

				#Train and ouput a model. Test validation set on the output model.
				if [ $TEST_TRAIN -eq 1 ]; then
					svm-train -c 2 -t 2 -g 0.1767767 -s 0 -m 400 $NGRAM_LINK/computation/train.data $NGRAM_LINK/computation/train.data.model
					svm-predict $NGRAM_LINK/computation/test_all.data $NGRAM_LINK/computation/train.data.model $NGRAM_LINK/result/predict.txt > $NGRAM_LINK/result/result.txt
				fi

				if [ $PREDICT_STAT -eq 1 ]; then
					rm -f $NGRAM_LINK/result/statistics.txt $NGRAM_LINK/result/accuracy_for_all_lang

					echo -e "\t SS \t AF \t ZUL \t EN \t TOTAL\n" >> $NGRAM_LINK/result/statistics.txt

					for lang in "ss" "afr" "zul" "eng"
					do
						echo -e "\nIdentification accuracy for ${lang} is: \n" >> $NGRAM_LINK/result/accuracy_for_all_lang

						svm-predict $NGRAM_LINK/computation/test_${lang}_scale $NGRAM_LINK/computation/train.data.model $NGRAM_LINK/result/predict_${lang} >> $NGRAM_LINK/result/accuracy_for_all_lang

						$SVM_SCRIPTS_DIR/estimate_total_result.pl $NGRAM_LINK/result/predict_${lang} ${lang} >> $NGRAM_LINK/result/statistics.txt
					done
				fi
			done
		done
	done
done

end=`date +%s.%N`
time=`echo "$end - $start" | bc`
# Tell the team of the outcome #################################################
curl -X POST --data-urlencode 'payload={"channel": "#gridjobs", "username": "gridjob", "text": "Libsvm processing of '"$2"' on '"$HOSTNAME"' took '"$time"' s. :wave::skin-tone-6:  ", "icon_emoji": ":labtocat:" }' https://hooks.slack.com/services/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
#  #############################################################################
