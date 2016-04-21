#!/bin/sh

#------------------------------------------------------
# REQUIRED
# Varibles which WILL be used, and which you MUST CHANGE
#------------------------------------------------------
# Full path to where the top-level directory within which the experiment will be created
export DIR_ROOT=~/asr
export DIR_MAIN=$DIR_ROOT
export DIR_EXP=$DIR_MAIN/exp
export DIR_SRC=$DIR_ROOT/asr_template/src
export DIR_CFG=$DIR_ROOT/asr_template/config

export LST_AUDIO_TRN_ORIG=$DIR_EXP/lists/audio_trn.lst
export LST_AUDIO_TST_ORIG=$DIR_EXP/lists/audio_eval.lst

export LST_TRANS_TRN_ORIG=$DIR_EXP/lists/trans_trn.lst
export LST_TRANS_TST_ORIG=$DIR_EXP/lists/trans_eval.lst

export DICT=$DIR_MAIN/dict/isindebele.dict
export DIR_SCRATCH="/tmp"

export TARGETKIND="MFCC_0_D_A_Z" # See HTK book for other types
export TRACE=1

export SENTSTART="<s>" # <s> is recommended since that is the default for srilm tools
export SENTEND="</s>" # </s> is recommended since that is the default for srilm tools

export NUM_HEREST_PROCS=1

# Trace levels for the different tools
#------------------------------------------------------
export TRACE_HEREST=1
export TRACE_HVITE=1
export TRACE_HHED=1
export TRACE_HLED=1
export TRACE_HCOMPV=1
export TRACE_HCOPY=1

#------------------------------------------------------
# Optional new variables
#------------------------------------------------------
export NUM_FILES_HCOMPV=500
#------------------------------------------------------
# REQUIRED for decoding
#------------------------------------------------------
export GRAMMAR=$DIR_EXP/grammar/grammar.txt
export INS_PENALTY=-15.0	
export GRAMMAR_SCALE=1.0
export MLF_RESULTS=$DIR_EXP/results/test_results.mlf

# If you're using Juicer
export JUTOOLS=~/local/src/juicer/juicer-0.12.0/bin
export MAINBEAM=200

#------------------------------------------------------
# REQUIRED for performing forced alignment
#------------------------------------------------------

export MLF_ALIGN_TRN=$DIR_EXP/results/align_train.mlf
export MLF_ALIGN_TST=$DIR_EXP/results/align_test.mlf

#normal alignment options - for state level add "-f"
export PARAMS_ALIGN="-a -m" 

#------------------------------------------------------
# REQUIRED if you're going to train language models for
# word recognition
#------------------------------------------------------
LIST_LM_TRN=
LM_NGRAM_ORDER=2
VOCABULARY=$DIR_EXP/models/grammar/vocabulary.txt # srilm_ngram will generate this if it doesn't exist

#------------------------------------------------------
# REQUIRED for CMVN
#------------------------------------------------------
# directory where mean vectors are saved
export CMEANDIR="$DIR_EXP/cmn_vectors"
# NB!!! All filenames in the list supplied to CMVN.sh (hcopy style list with
# one audio and one feature file name line) has to match the regular
# expressions defined below (AUDIO_CMEANMASK, MFCC_CMEANMASK, AUDIO_VARSCALEMASK,
# MFCC_VARSCALEMASK) respectively (wav = AUDIO, mfc = MFCC). If even one
# filename is not matchable, the process will break.

# AUDIO_CMEANMASK should match the raw audio filenames
# EXAMPLE: AUDIO_CMEANMASK="/home/cvheerden/data/lwazi/lwazi_english_1_0/audio/???/%%%_english*"
# % - characters that match this will form the cluster id name (in above example, this will create speaker clusters, since first 3 characters of filename id the speaker)
# ? - characters that match this will be ignored (one character per ?)
# * - match 0 or more characters to be ignoredls
export AUDIO_CMEANMASK="$DIR_MAIN/data/audio/??????_%%%/??????_%%%_%%.wav" #???/%%%_??????_??_??_%%.wav"

# MFCC_CMEANMASK should match the mfcc filenames. NB - the same speaker clusters MUST be formed, otherwise results are unpredictable
# If your directory structure where mfccs are extracted to is the same as the original audio, it's easy. Given above example, this will then simply be
# EXAMPLE: MFCC_CMEANMASK="/home/cvheerden/data/lwazi/lwazi_english_1_0/mfccs/???/%%%_english*"
export MFCC_CMEANMASK="$DIR_EXP/data/mfccs/??????_%%%_%%.mfc" #%%%_??????_??_??_%%.mfc
# directory where variance vectors are saved
export VARSCALEDIR="$DIR_EXP/cvn_vectors"

# Should be identical to the CMN masks, unless you want to do interesting things. Leaving you with that option. If not, simply make them the same as CMN masks
export AUDIO_VARSCALEMASK=$AUDIO_CMEANMASK
export MFCC_VARSCALEMASK=$MFCC_CMEANMASK

# If you don't set GLOBALVARMASK, but switch on variance normalization, the target variance will be 1.0 (CvH got better results on a dev set for Lwazi English with unit variance; htk book recommends global variance though). Alternatively, if you want to scale the normalized variance to the global variance, you have to provide a MASK that matches the extracted mfccs (eg, matching on english for lwazi will create a single variance cluster:
# EXAMPLE: GLOBVARMASK=/home/cvheerden/data/lwazi/lwazi_english_1_0/mfccs/???/???_%%%%%%%*
# If not set, defaults to scaling variance to all 1.0
export GLOBALVARMASK="$DIR_EXP/data/mfccs/??????_%%%_%%.mfc" #%%%_%%.mfc"
#export GLOBALVARMASK=""
# Name of global variance estimate. This name should match whatever '%%%%%%' matches in GLOBALVARMASK (from GLOBVARMASK EXAMPLE, it should be 'english', since 'english' is matched, otherwise leave as is).
# If you don't set GLOBALVARMASK, $VARSCAEFN can be named anything and it will be created.
# EXAMPLE: export VARSCALEFN="$DIR_EXP/cvn_vectors/english"
export VARSCALEFN="$DIR_EXP/cvn_vectors/globvariance"

export CFG_HCOPY_CMN=$DIR_EXP/config/hcopy.cmn.conf
export CFG_HCOPY_CVN=$DIR_EXP/config/hcopy.cvn.conf
export CFG_HCOPY_CMVN=$DIR_EXP/config/hcopy.cmvn.conf

#------------------------------------------------------
# OPTIONAL
# Varibles which MAY be used depending on what you choose to do,
# in which case you MUST CHANGE them
#------------------------------------------------------
export FILE_PUNCT=$DIR_CFG/punctuation.txt

#------------------------------------------------------
# OPTIONAL, but shouldn't need to be changed
# Variables pointing to ASR Resources.
# Everything listed here WILL be created. By setting it, you pledge to provide a VALID alternative at your own risk
#------------------------------------------------------
# TODO(Everyone): Do we want such an overide? Currently inactive
export HMM_OVERIDE_INDEX= # WARNING: Setting this variable will force the script to resume whichever training process
                          #          you specify, from HMM_OVERIDE_INDEX

export HMM_PREV=-1
export HMM_CURR=0
export HMM_NEXT=1
export DIR_HMM_CURR=$DIR_EXP/models/hmm_$HMM_CURR
export DIR_HMM_PREV=$DIR_EXP/models/hmm_$HMM_PREV
export DIR_HMM_NEXT=$DIR_EXP/models/hmm_$HMM_NEXT

export LOG_MONO_TRAIN=$DIR_EXP/logs/mono_train.log
export LOG_TMP=$DIR_SCRATCH/tmp.log
export MIN_OBS=5 # Minimum number of observations in the parameter file 

export NUM_MIXES=16 # Number of times mixtures will be incremented
export MIX_INCREMENT=2 # If you change this, you have to do the logic yourself to set NUM_MIXES
export DICT_BASE=$DIR_EXP/dictionaries/baseline.dict
export DICT_SP=$DIR_EXP/dictionaries/baseline_sp.dict

export VFLOORS=$DIR_EXP/models/hmm_0/vFloors
export VFLOORS_SCALE="0.01"
export PROTO_RAW=$DIR_EXP/models/proto
export PROTO_SET=$DIR_EXP/models/hmm_0/proto

export LIST_MONOPHNS=$DIR_EXP/lists/monophones.lst
export LIST_MONOPHNS_SP=$DIR_EXP/lists/monophones_sp.lst
export LIST_AUDIO_TRN=$DIR_EXP/lists/audio_trn.lst
export LIST_AUDIO_TST=$DIR_EXP/lists/audio_tst.lst
export LIST_TRANS_TRN=$DIR_EXP/lists/trans_trn.lst
export LIST_TRANS_TST=$DIR_EXP/lists/trans_tst.lst
export LIST_FULL=$DIR_EXP/lists/fulllist.lst
export LIST_TIED=$DIR_EXP/lists/tiedlist.lst
export LIST_TRI=$DIR_EXP/lists/triphones.lst
export LIST_WORDS_ALL=$DIR_EXP/lists/words_all.lst
export LIST_WORDS_TRN=$DIR_EXP/lists/words_trn.lst
export LIST_WORDS_TST=$DIR_EXP/lists/words_tst.lst

export MLF_WORDS_ALL=$DIR_EXP/mlfs/words_all.mlf
export MLF_WORDS_TRN=$DIR_EXP/mlfs/words_trn.mlf
export MLF_WORDS_TST=$DIR_EXP/mlfs/words_tst.mlf
export MLF_PHNS_ALL=$DIR_EXP/mlfs/monophones_all.mlf
export MLF_PHNS_TRN=$DIR_EXP/mlfs/monophones_trn.mlf
export MLF_PHNS_TST=$DIR_EXP/mlfs/monophones_tst.mlf
export MLF_TRIPHNS_TRN=$DIR_EXP/mlfs/triphones_trn.mlf
export MLF_TRIPHNS_TRN_BACKUP=$DIR_EXP/mlfs/triphones_trn_backup.mlf
export MLF_PHNS_SP_TRN=$DIR_EXP/mlfs/monophones_sp_trn.mlf
export MLF_PHNS_SP_TST=$DIR_EXP/mlfs/monophones_sp_tst.mlf
export MLF_PHNS_ALIGN_TRN=$DIR_EXP/mlfs/monophones_align_trn.mlf
export MLF_PHNS_ALIGN_TST=$DIR_EXP/mlfs/monophones_align_tst.mlf

export QUESTIONS_FILE=$DIR_EXP/config/quests.txt
export STATS=$DIR_EXP/config/stats
export TREES=$DIR_EXP/config/trees

export CFG_SEMITIED=$DIR_EXP/config/semit.cfg
export CFG_HVITE=$DIR_EXP/config/hvite.cfg
export CFG_HCOPY=$DIR_EXP/config/hcopy.cfg
export CFG_HCOMPV=$DIR_EXP/config/hcompv.cfg
export CFG_HEREST=$DIR_EXP/config/herest.cfg

export LED_MERGE=$DIR_EXP/config/merge_phns.led
export LED_MKPHONES=$DIR_EXP/config/mkphns.led
export LED_MKPHONES_SP=$DIR_EXP/config/mkphns_sp.led
export LED_MKWORDS=$DIR_EXP/config/mkwords.led
export LED_MKBI=$DIR_EXP/config/mkbi.led
export LED_MKTRI=$DIR_EXP/config/mktri.led
export LED_MKBI_XWORD=$DIR_EXP/config/mkbixword.led
export LED_MKTRI_XWORD=$DIR_EXP/config/mktrixword.led

export HED_SIL=$DIR_EXP/config/sil.hed
export HED_MKBI=$DIR_EXP/config/mkbi.hed
export HED_MKTRI=$DIR_EXP/config/mktri.hed
export HED_MIX_INC=$DIR_EXP/config/mix_inc.hed
export HED_REGTREE=$DIR_EXP/config/regtree.hed
export HED_TREE=$DIR_EXP/config/trees.hed

export DED_GLOBAL_MONO=$DIR_EXP/config/global_mono.ded
export DED_GLOBAL_WORD=$DIR_EXP/config/global_word.ded
export DED_GLOBAL_BI=$DIR_EXP/config/global_bi.ded
export DED_GLOBAL_TRI=$DIR_EXP/config/global_tri.ded
export DED_REALIGN=$DIR_EXP/config/realign.ded
export DED_GLOBAL_TEST=$DIR_EXP/config/global_tst.ded

# HCOPY / HCOMPV
export CEPLIFTER="22"
export ENORMALISE="FALSE" # Must be F if live recognition is to be performed
export NUMCEPS="12"
export NUMCHANS="26"
export PREEMCOEF="0.97"
export SAVECOMPRESSED="FALSE"
export SAVEWITHCRC="FALSE"
export TARGETRATE="100000.0"
export USEHAMMING="TRUE"
export WINDOWSIZE="250000.0"
export SOURCEFORMAT="WAVE"
export ZMEANSOURCE="TRUE"
export LOFREQ="150"
export HIFREQ="4000"

# HEREST
export HEREST_PRUNE="250.0 150.0 1000.0"

# HVITE
export THR_HVITE_PRUNE="0.0" # This may need to be changed

# HADAPT
export HADAPT_TRACE=61
export HADAPT_TRANSKIND="SEMIT"
export HADAPT_USEBIAS="FALSE"
export HADAPT_BASECLASS="$DIR_EXP/models/hmm_36/regtree_2.base" # TODO(User): This needs to be determined on a per experiment basis: Example: $DIR_EXP/models/hmm_33/regtree_2.base
export HADAPT_ADAPTKIND="BASE"
export HADAPT_SPLITTHRESH="0.0"
export HADAPT_SEMITIEDMACRO="$DIR_EXP/models/hmm_36/SEMITIED" # TODO(User): Set at experiment level. Example: $DIR_EXP/models/hmm_33/SEMITIED
export HADAPT_MAXXFORMITER=100
export HADAPT_MAXSEMITIEDITER=20

# HMODEL
export HMODEL_SAVEBINARY="FALSE"
export HMODEL_TRACE=512


#------------------------------------------------------
# OWN RISK
# Varibles you may change, but AT YOUR OWN RISK
#------------------------------------------------------

#------------------------------------------------------
# Varibles you should not change
#------------------------------------------------------
export bold_begin='\e[1m'
export bold_end='\e[0m'
