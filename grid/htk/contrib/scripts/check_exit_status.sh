#!/bin/bash
# Author: Neil Kleynhans (ntkleynhans@csir.co.za)

PROG_NAME=$1
EXIT_CODE=$2

EXPECTED_NUM_ARGS=2
E_BAD_ARGS=65

if [ $# -ne $EXPECTED_NUM_ARGS ]; then
  echo "Usage: ./check_exit_status.sh program_name exit_status"
  exit $E_BAD_ARGS
fi

# Check exit code
if [ "$EXIT_CODE" -ne "0" ]; then
    echo "ERROR ($EXIT_CODE): A command in $PROG_NAME did not exit correctly. Please check the log file" #TODO: must determine log file
    exit $EXIT_CODE
fi

