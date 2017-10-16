#!/bin/bash

################################################################################
## Feature  : Wrap kinds of enter*.sh
## Author   : ZhangLue
## Date     : 2017.05.03
################################################################################

_usage()
{
    echo "usage:"
    echo $1
}
_error()
{
    echo "error:"
    echo $1
}

if (( $# < 2 )); then
    _usage 0
elif [[ $1 != '-t' ]] && [[ $1 != '--type' ]]; then
    _usage 0
else
    shift
    type_ED="$1"
    processCMD_ED='enterDir'
    case $type_ED in 
        1 | ListChoose )
            processCMD_ED="${processCMD_ED}ListChoose.sh"
            ;;
        2 | GitSvnTop )
            processCMD_ED="${processCMD_ED}GitSvnTop.sh"
            ;;
        * )
            _usage 1
    esac
    shift
    if [[ $processCMD_ED != 'enterDir' ]]; then
        \which "${processCMD_ED}" > /dev/null 2>&1
        if (( $? )); then
        #if (( 0 )); then
            _error 0
        else
            export transFile_ED=`mktemp`
            ${processCMD_ED} "$@"
            if (( ! $? )); then
                dirToEnter_ED=`cat $transFile_ED | tail -n 1`
                if [[ -d $dirToEnter_ED ]]; then
                    builtin cd $dirToEnter_ED
                #else
                #    _error 1
                fi
            fi
            \rm -f $transFile_ED > /dev/null 2>&1
        fi
    fi
fi
