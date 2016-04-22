#!/bin/bash
# CODE-RADE HTK Feature Extraction
# Author : Bruce Becker
#        : https://github.com/brucellino
#        : CSIR Meraka
# ########################################
# See the README.md in the repo
#  This script builds on the original ASR template
#  We can stage some HTK data from UJ
#  And run feature extraction
# ########################################
start=`date +%s.%N`
curl -X POST --data-urlencode 'payload={"channel": "#gridjobs", "username": "gridjob", "text": "HTK on '"$HOSTNAME"', starting feature extraction on data chunk '"$2"' with Repo '"$1"' ", "icon_emoji": ":labtocat:"}' https://hooks.slack.com/services/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
# Taking from the "system.sh" script in ASR, we first set up the workind dirs :
export DIR_EXP=$PWD

echo "Is the input data here ? "
ls -lht

for dir in  data/mfccs  log  data/proc_trans  lists/  data/audio  log ; do
  mkdir -p $dir
done
ls $DIR_EXP

# Put the data into  data/audio
# We will use just one chunk - this is passed as the argument
echo "Staging chunk $2"
# time globus-url-copy -vb -fast -p 5 gsiftp://fs01.grid.uj.ac.za/dpm/grid.uj.ac.za/home/sagrid/hlt-nwu/data/audio/isindebele_$2.tar.gz file:$PWD/isindebele_$2.tar.gz
ls -lht isindebele_$2.tar.gz
tar xvfz isindebele_$2.tar.gz -C  data/audio/

echo ""
echo "FEATURE EXTRACTION"
# this will create a list  file associating a WAV with an "MFC" file.
# this list is kept in a file - hcopylist.lst
# It is done by running a perl script
echo "creating hcopylist.lst"
date >>  log/time.feat
perl  create_hcopy_lists.pl  data/audio  data/mfccs  lists/hcopylist.lst
echo "running: CMVN.sh cmvn"
./CMVN.sh cmvn  lists/hcopylist.lst >&  log/feature.log
date >>  log/time.feat
cat log/time.feat
end=`date +%s.%N`
time=`echo "$end - $start" | bc`
curl -X POST --data-urlencode 'payload={"channel": "#gridjobs", "username": "gridjob", "text": "Feature extraction of data chunk '"$2"' on '"$HOSTNAME"' took '"$time"' s. :wave::skin-tone-6:  ", "icon_emoji": ":labtocat:" }' https://hooks.slack.com/services/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

exit 0;
