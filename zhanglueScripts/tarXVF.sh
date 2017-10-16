#!/bin/bash

################################################################################
## Feature  : tar xvf accoording to the format of file.
## Author   : work
## Date     : 2017.04.11
################################################################################

################################################################################
##  CHECK THE COMPLETENESS FIRST OF ALL
################################################################################
COMMON_FILE="${DIR_SCRIPTS}/common.sh"
. $COMMON_FILE
################################################################################

echo 
if (( ! $# )); then
    _echo_error
    echo 'Specify the tar file.'
    echo 
    exit 1
fi

fileType=`\file $1`
mode='-xvf'

if [[ -n `echo $fileType | grep 'gzip compressed data'` ]]; then
    mode='-xzvf'
elif [[ -z `echo $fileType | grep 'POSIX tar archive'` ]]; then
    _echo_error
    echo "$1 is not a tar nor a tgz."
    echo
    exit 2
fi

\tar $mode $1

echo
