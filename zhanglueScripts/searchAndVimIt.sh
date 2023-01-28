#!/bin/bash

################################################################################
## Feature  : Search some typical code and vim the file.
## Author   : Lucas Zhang
## Date     : 2022.07.29
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

_usage()
{
    echo
    echo "Usage:"
    echo
}

_exit()
{
    exit $1
}

_search_and_save_results()
{
    searchPath="$1"
    pattern="$2"
    resultFile=$3
    excludeTestFiles=$4
    definationOnly=$5
    cmd=""

    if (( $definationOnly ))
    then
        pattern="\(class\|enum\) $pattern"
    fi

    if (( $excludeTestFiles ))
    then
        cmd="find ${searchPath:-.} -regex '.*[Tt]est.*\|.*~$\|.*/\.\(git\|hg\|svn\)\(/\|$\)' -prune -o -type f -print0 | \
xargs -r0 grep -HnIi --color=always \"${pattern}\""
    # elif [[ ]]
    # then
    else
        cmd="find ${searchPath:-.} -regex '.*~$\|.*/\.\(git\|hg\|svn\)\(/\|$\)' -prune -o -type f -print0 | \
xargs -r0 grep -HnIi --color=always \"${pattern}\""
    fi

    ## For debugging:
    #echo "------------------------------------------"
    #echo "searchPath        : $searchPath"
    #echo "pattern           : $pattern"
    #echo "resultFile        : $resultFile"
    #echo "excludeTestFiles  : $excludeTestFiles"
    #echo "definationOnly    : $definationOnly"
    #echo "eval $cmd"
    #echo "------------------------------------------"

    if [[ "${resultFile}" == "NO_RESULT_FILE" ]]; then
        eval $cmd
        exit 0
    fi

    cmd="$cmd | awk -F ' ' '{ print \"\033[33m\" NR \"\033[36m:\" \$0 }' > $resultFile"
    eval $cmd

    cat $resultFile | while read line
    do
        echo $line | cut -d ':' -f -3
        echo $line | cut -d ':' -f 4-
        echo
    done
}

_select()
{
    resultIndex=$1
    resultFile=$2
    line=$(cat $resultFile | head -n $resultIndex | tail -n 1 | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g")
    filePath=$(echo $line | cut -d ':' -f 2)
    lineNum=$(echo $line | cut -d ':' -f 3)
    vim +$lineNum $filePath
}

################################################################################
## MAIN
################################################################################
if (( $# == 0 )); then
    _usage
    _exit 1
fi

executeType=''
pattern=''
searchPath=''
resultFile='NO_RESULT_FILE'
excludeTestFiles=0
definationOnly=0

while (( $# != 0 ))
do
    curArg="$1"
    shift

    if [[ ${curArg} == "--exclude-tests" ]]; then
        excludeTestFiles=1
        continue
    fi

    if [[ ${curArg} == "--defination-only" ]]; then
        definationOnly=1
        continue
    fi

    if [[ -z ${executeType} ]]; then
        executeType="${curArg}"
        continue
    fi

    if [[ -z ${pattern} ]]; then
        pattern="${curArg}"
        resultIndex="${curArg}"
        continue
    fi

    if [[ -z "${searchPath}" ]]; then
        searchPath="${curArg}"
        continue
    fi

    _usage
    _exit 2
done

if [[ -z ${pattern} ]]; then
    _usage
    exit 3
fi

case "${executeType}" in
    search )
        cmdStr="_search_and_save_results"
        ;;
    search_and_save )
        resultFile="/tmp/search_and_vim_it_temp_file"
        cmdStr="_search_and_save_results"
        ;;
    select )
        resultFile="/tmp/search_and_vim_it_temp_file"
        cmdStr="_select ${resultIndex} ${resultFile}"
        ;;
    *)
        _usage
        _exit 4
        ;;
esac

if [[ ${executeType} != "select" ]]; then
    cmdStr="${cmdStr} \"${searchPath:-.}\" \"${pattern}\" ${resultFile} ${excludeTestFiles} ${definationOnly}"
fi

eval $cmdStr
