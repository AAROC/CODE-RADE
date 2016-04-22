#!/bin/bash
# Author: Charl van Heerden (cvheerden@csir.co.za)
#
# Given a hcopy-style list, performs cvn
# 
# Important:
# - you have to set the appropriate variables under CMVN in Vars.sh

FLAG=$1
LIST=$2

#============================================================
# Check that the number of arguments are correct
#============================================================
EXPECTED_NUM_ARGS=2
E_BAD_ARGS=65

if [ $# -lt $EXPECTED_NUM_ARGS ]; then
	echo "Usage: ./cvn.sh <option> <list> (+ you HAVE to set the variables under CMVN in Vars.sh)"
  printf "\n\t$bold_begin%-10s$bold_end%s\n" "<option>" "customize training:"
  printf "\n\t%-4s $bold_begin%-12s$bold_end\t%s\n" "" "cvn" "- perform only cepstral variance normalization"
  printf "\n\t%-4s $bold_begin%-12s$bold_end\t%s\n" "" "cmvn" "- perform second of two steps for cmvn (first step using cvn.sh required)"
  printf "\n\t$bold_begin%-10s$bold_end%s\n" "<list>" "text file, with two FULL PATHS per line: <file in> <file out>"
  printf "\n\t$bold_begin%-10s$bold_end%s\n" "      " "<file in>  - should be an audio file (probably wav)"
  printf "\n\t$bold_begin%-10s$bold_end%s\n" "      " "<file out> - should be an mfc file that will be created"

  exit $E_BAD_ARGS
fi

#============================================================
# Some Basic checks and setup
#============================================================
if [ ! -s $LIST ]; then
  echo -e "ERROR: LIST <$LIST> does not exist!"
  exit $E_BAD_ARGS
fi

if [ ! -d $DIR_SRC ]; then
  echo -e "ERROR: Please set $bold_begin DIR_SRC $bold_end in Vars.sh to valid directory"
  exit $E_BAD_ARGS
fi

if [ ! -d $DIR_EXP/config ]; then
  echo -e "WARNING: Creating $DIR_EXP/config"
  mkdir -p $DIR_EXP/config
fi

if [ ! -d $DIR_EXP/log ]; then
  echo -e "WARNING: Creating $DIR_EXP/log"
  mkdir -p $DIR_EXP/log
fi

if [ ! -d $DIR_SCRATCH ]; then
  echo -e "WARNING: DIR_SCRATCH: <$DIR_SCRATCH> doesn't exist"
  exit $E_BAD_ARGS
fi

if [ ! -w $DIR_SCRATCH ]; then
  echo -e "ERROR: DIR_SCRATCH: <$DIR_SCRATCH> not writable"
  exit $E_BAD_ARGS
fi

if [ $FLAG = 'cmvn' ]; then
  if [ ! -s $CFG_HCOPY_CMVN ]; then
    echo "ERROR: cmvn hcopy config doesn't exists. Did you run ./cmn.sh? ($CFG_HCOPY_CMVN)";
    exit $E_BAD_ARGS
  fi
fi

# SELECT THE APPROPRIATE HCOPY CONFIG
LOCAL_CFG_HCOPY=$CFG_HCOPY_CMVN
if [ $FLAG = 'cvn' ]; then
  LOCAL_CFG_HCOPY=$CFG_HCOPY_CVN
fi

echo "LOCAL_CFG_HCOPY=$LOCAL_CFG_HCOPY"

# Create a local mfcc list
LOCAL_MFCC_LIST=$DIR_SCRATCH/all.mfccs.lst
cat $LIST | awk '{print $2}' > $LOCAL_MFCC_LIST
echo "Creating a local mfcc list: $LOCAL_MFCC_LIST"

# Features don't need to be extracted again for cmvn
if [ $FLAG = 'cvn' ]; then
  # (1) Extract features without normalization
  export TARGETKIND="MFCC_0_D_A_Z"
  # TODO: It may be cleaner to move this to create_configs once this is well tested
  bash $DIR_SRC/create_configs.sh hcopy $LOCAL_CFG_HCOPY

  # Do feature extraction
  echo "Extracting features: <$TARGETKIND>"
  HCopy -A -T $TRACE -C $LOCAL_CFG_HCOPY -S $LIST
  echo "Creating backup of <$LOCAL_CFG_HCOPY> at <$DIR_SCRATCH/$LOCAL_CFG_HCOPY.cvna>"
  cp $LOCAL_CFG_HCOPY $DIR_SCRATCH/hcopy.cvna
fi

# (2.1) Estimate cluster variance
if [ ! -d $VARSCALEDIR ]; then
  echo -e "WARNING: Creating $VARSCALEDIR"
  mkdir -p $VARSCALEDIR
fi

echo "HCompV -A -T $TRACE +++ -C +++ $VARSCALEDIR -k \"$MFCC_VARSCALEMASK\" -q v -S $LOCAL_MFCC_LIST"
HCompV -A -T $TRACE -C $VARSCALEDIR -k "$MFCC_VARSCALEMASK" -q v -S $LOCAL_MFCC_LIST

# (2.2) Estimate global variance, or use all 1's if no global mask
if [ -z $GLOBALVARMASK ]; then
  echo "<VARSCALE> 39" > $VARSCALEFN
  echo " 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00 1.000000e+00" >> $VARSCALEFN
else
  echo "HCompV -A -T $TRACE ++ -C $VARSCALEDIR -k \"$GLOBALVARMASK\" -q v -S $LOCAL_MFCC_LIST"
  HCompV -A -T $TRACE -C $VARSCALEDIR -k "$GLOBALVARMASK" -q v -S $LOCAL_MFCC_LIST
  # TODO: Anyone has any idea how to tell HTK to print VARSCALE instead of CEPSNORM & VARIANCE?
  sed -i '/CEPSNORM/d' $VARSCALEFN
  sed -i 's/VARIANCE/VARSCALE/' $VARSCALEFN
fi 

# (3) Extract features again, this time doing normalization given the cluster means and/or vairiances
echo "HPARM:VARSCALEDIR  = '$VARSCALEDIR'" >> $LOCAL_CFG_HCOPY 
echo "HPARM:VARSCALEMASK = '$AUDIO_VARSCALEMASK'" >> $LOCAL_CFG_HCOPY
echo "HPARM:VARSCALEFN   = '$VARSCALEFN'" >> $LOCAL_CFG_HCOPY

# Do feature extraction
echo "Extracting features: <$TARGETKIND>"
HCopy -A -T $TRACE -C $LOCAL_CFG_HCOPY -S $LIST

bash $DIR_SRC/check_exit_status.sh $0 $?
