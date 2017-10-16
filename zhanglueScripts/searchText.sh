#!/bin/bash

################################################################################
## Feature  : Search text in files.
## Author   : ZhangLue 
## Date     : 2017.04.14
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
## MAIN
################################################################################
if (( $# == 0 )); then
    _usage
    exit 1
fi

while (( $# != 0 ))
do
    curArg="$1"
    shift 1

    if [[ -z "$pattern" ]]; then
        if [[ "$curArg" == "--" ]]; then
            grepArgs="$grepArgs $curArg"
            pattern="$1"
            shift 1
        elif [[ "${curArg:0:1}" != "-" ]]; then
            pattern="$curArg"
        else
            grepArgs="$grepArgs $curArg"
        fi
    else
        pathArgs="$pathArgs $curArg"
    fi
done

find \
    $pathArgs \
    -regex ${WCGREP_IGNORE:-'.*~$\|.*/\.\(git\|hg\|svn\)\(/\|$\)'} \
    -prune \
    -o \
    -type f \
    -print0 \
  | xargs \
    -r0 \
    ${WCGREP_GREP:-grep} --color \
    ${WCGREP_GREPARGS:--HnI} $grepArgs "$pattern"
