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
curl -X POST --data-urlencode 'payload={"channel": "#gridjobs", "username": "gridjob", "text": "HTK on '"$HOSTNAME"', starting feature extraction on data chunk '"$2"' with Repo '"$1"' ", "icon_emoji": ":labtocat:"}' https://hooks.slack.com/services/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
# Taking from the "system.sh" script in ASR, we first set up the workind dirs :
export DIR_EXP=$PWD

for dir in $DIR_EXP/data/mfccs $DIR_EXP/log $DIR_EXP/data/proc_trans $DIR_EXP/lists/ $DIR_EXP/data/audio $DIR_EXP/log ; do
  mkdir -p $dir
done
ls $DIR_EXP

# Put the data into $DIR_EXP/data/audio
# We will use just one chunk - this is passed as the argument
echo "Staging chunk $2"
time globus-url-copy -vb -fast -p 5 gsiftp://fs01.grid.uj.ac.za/dpm/grid.uj.ac.za/home/sagrid/hlt-nwu/data/audio/isindebele_$2.tar.gz file:$PWD/isindebele_$2.tar.gz
ls -lht isindebele_$2.tar.gz
tar xvfz isindebele_$2.tar.gz -C $DIR_EXP/data/audio/

curl -X POST --data-urlencode 'payload={"channel": "#gridjobs", "username": "gridjob", "text": "Data chunk '"$2"' finishing on '"$HOSTNAME"'. :wave::skin-tone-6:  ", "icon_emoji": ":labtocat:"}' https://hooks.slack.com/services/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

exit 0;


echo ""
echo "FEATURE EXTRACTION"
# this will create a list  file associating a WAV with an "MFC" file.
# this list is kept in a file - hcopylist.lst
# It is done by running a perl script
echo "creating hcopylist.lst"
date >> $DIR_EXP/log/time.feat
perl $DIR_EXP/contrib/scripts/create_hcopy_lists.pl $MAIN_DIR1/data/audio $DIR_EXP/data/mfccs $DIR_EXP/lists/hcopylist.lst
cd $DIR_EXP/src
echo "running: CMVN.sh cmvn"
bash CMVN.sh cmvn $DIR_EXP/lists/hcopylist.lst >& $DIR_EXP/log/feature.log
date >> $DIR_EXP/log/time.feat
