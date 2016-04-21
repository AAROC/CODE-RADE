#!/bin/bash
# CODE-RADE HTK Data Staging
# Author : Bruce Becker
#        : https://github.com/brucellino
#        : CSIR Meraka
# ########################################
# See the README.md in the repo
# This script runs a simple check to see if
#  We can stage some HTK data from UJ
# it is a standalone script to be used with exmaple 2
# ########################################
curl -X POST --data-urlencode 'payload={"channel": "#hlt-research", "username": "gridjob", "text": "This is a job running on the grid at '"$HOSTNAME"'. Will be processing data chunk '"$2"' with Repo '"$1"' ", "icon_emoji": ":labtocat:"}' https://hooks.slack.com/services/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
# Taking from the "system.sh" script in ASR, we first set up the workind dirs :
export DIR_EXP=$PWD

for dir in $DIR_EXP/data/mfccs $DIR_EXP/log $DIR_EXP/data/proc_trans $DIR_EXP/lists/ $DIR_EXP/data/audio ; do
  mkdir -p $dir
done
ls $DIR_EXP

# Put the data into $DIR_EXP/data/audio
# We will use just one chunk - this is passed as the argument
echo "Staging chunk $2"
time globus-url-copy -vb -fast -p 5 gsiftp://fs01.grid.uj.ac.za/dpm/grid.uj.ac.za/home/sagrid/hlt-nwu/data/audio/isindebele_$2.tar.gz file:$PWD/isindebele_$2.tar.gz
ls -lht isindebele_$2.tar.gz
tar xvfz isindebele_$2.tar.gz -C $DIR_EXP/data/audio/

echo "size of the data is "
du -chs $DIR_EXP/data/audio
exit 0;
