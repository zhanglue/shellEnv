#!/bin/bash

################################################################################
## Feature  : Search text in files.
## Author   : zhanglue 
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
    shift

    if [[ -n "$pattern" ]]; then
        pathArgs="$pathArgs $curArg"
        continue
    fi

    if [[ "$curArg" == "--" ]]; then
        grepArgs="$grepArgs $curArg"
        pattern="$1"
        shift 1
        continue
    fi

    if [[ "${curArg:0:1}" == "-" ]]; then
        if [[ "${curArg}" == '-v' ]]; then
            AntiGrep="$1"
            shift
        else
            grepArgs="$grepArgs $curArg"
        fi
        continue
    fi

    pattern="$curArg"
done

if [[ -n $AntiGrep ]]; then
    find \
        ${pathArgs:-.} \
        -regex ${WCGREP_IGNORE:-'.*~$\|.*/\.\(git\|hg\|svn\)\(/\|$\)'} \
        -prune \
        -o \
        -type f \
        -print0 \
      | xargs \
        -r0 \
        ${GREP_BIN:-grep} \
        ${GREP_PARAMS:--HnI -i --color} $grepArgs "$pattern" \
      | grep -v "$AntiGrep"
else
    find \
        ${pathArgs:-.} \
        -regex ${WCGREP_IGNORE:-'.*~$\|.*/\.\(git\|hg\|svn\)\(/\|$\)'} \
        -prune \
        -o \
        -type f \
        -print0 \
      | xargs \
        -r0 \
        ${GREP_BIN:-grep} \
        ${GREP_PARAMS:--HnI -i --color} $grepArgs "$pattern"
fi
