#!/bin/bash

################################################################################
## Feature  : Find the file and vim it.
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

_find_and_vim()
{
    executeType="$1"
    pattern="$2"
    findPath="$3"

    cmd="find \"${findPath:-.}\" -type f -name \"${pattern}\" 2>/dev/null | sort > ${RESULT_FILE} 2>/dev/null"

    # # For debugging:
    # echo "------------------------------------------"
    # echo "executeType : $executeType"
    # echo "findPath    : $findPath"
    # echo "pattern     : $pattern"
    # echo "resultFile  : $RESULT_FILE"
    # echo "eval $cmd"
    # echo "------------------------------------------"

    eval $cmd

    resultCount=$( cat ${RESULT_FILE} | wc -l )

    if (( $resultCount == 0 )); then
        echo ""
        echo "No file found."
        echo ""
        _exit 1
    fi

    if [[ $resultCount == 1 && "${executeType}" == "find_and_vim_it" ]]; then
        vim $( cat ${RESULT_FILE} )
        _exit 0
    fi

    digitNum=0
    while (( $resultCount ))
    do
        digitNum=$(( digitNum + 1 ))
        resultCount=$(( resultCount / 10 ))
    done

    pattern=${pattern%%\*}
    pattern=${pattern##\*}
    patternArr=( $(echo ${pattern} | sed "s,\\*,\n,g" ) )
    postfix=""
    for (( i = 0 ; i < ${#patternArr[@]} ; i++))
    do
        postfix="$postfix | grep --color=always ${patternArr[${i}]}"
    done

    cat ${RESULT_FILE} | while read line
    do
        resultCount=$(( resultCount + 1 ))
        cmd="printf \"\033[35m%0${digitNum}d\033[32m: \033[33m%s\033[0m\n\" $resultCount $line $postfix"
        eval $cmd
    done
}

_select_to_vim()
{
    resultIndex=$1
    resultLine=$( cat ${RESULT_FILE} | head -n $resultIndex 2>/null | tail -n 1 2>/null )
    cmd="vim $resultLine"

    echo ""
    echo $cmd
    echo ""
    read

    eval $cmd
}

################################################################################
## MAIN
################################################################################
if (( $# == 0 )); then
    _usage
    _exit 1
fi

RESULT_FILE="/tmp/find_and_vim_it_temp_file"

executeType=''
pattern=''
findPath=''

while (( $# != 0 ))
do
    curArg="$1"
    shift

    if [[ -z ${executeType} ]]; then
        executeType="${curArg}"
        continue
    fi

    if [[ -z ${pattern} ]]; then
        pattern="${curArg}"
        resultIndex="${curArg}"
        continue
    fi

    if [[ -z "${findPath}" ]]; then
        findPath="${curArg}"
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
    find_and_vim_it | find_only )
        cmdStr="_find_and_vim ${executeType} \"${pattern}\" \"${findPath:-.}\""
        ;;

    select_to_vim )
        cmdStr="_select_to_vim ${resultIndex}"
        ;;

    *)
        _usage
        _exit 4
        ;;
esac

eval $cmdStr
