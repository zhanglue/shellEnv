#!/bin/bash

################################################################################
## Feature  : decode the input URL.
## Author   : ZhangLue
## Date     : 2016.09.05
################################################################################

################################################################################
##  CHECK THE COMPLETENESS FIRST OF ALL
################################################################################
if [[ -z ${DIR_SCRIPTS} ]] ||
   [[ ! -s "${DIR_SCRIPTS}/common.sh" ]] 
then
    echo
    echo '${DIR_SCRIPTS}/common.sh is not correct.'
    echo
    exit 99
fi

COMMON_FILE="${DIR_SCRIPTS}/common.sh"
. $COMMON_FILE

################################################################################

_decodeURL $1
