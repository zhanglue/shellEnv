#!/bin/bash

################################################################################
## Feature  : Swicth GCC.
## Author   : zhanglue
## Date     : 2017.08.08
################################################################################

: ${V6G:='/home/zhanglue/.jumbo/opt/gcc46/bin'}
V6GS=$( echo $V6G | sed 's,/,\\/,g')
: ${V6L:='/home/zhanglue/.jumbo/opt/gcc46/lib64'}
V6LS=$( echo $V6L | sed 's,/,\\/,g')

: ${V8G='/home/zhanglue/.jumbo/opt/gcc48/bin'}
V8GS=$( echo $V8G | sed 's,/,\\/,g')
: ${V8L='/home/zhanglue/.jumbo/opt/gcc48/lib64'}
V8LS=$( echo $V8L | sed 's,/,\\/,g')

_clean_gcc_in_path()
{
    if [[ -n $(echo ${PATH} | grep ${V6G}) ]]; then
        PATH=$(echo ${PATH} | sed "s/${V6GS}//g")
    fi

    if [[ -n $(echo ${PATH} | grep ${V8G}) ]]; then
        PATH=$(echo ${PATH} | sed "s/${V8GS}//g")
    fi

    if [[ -n $(echo ${LD_LIBRARY_PATH} | grep ${V6L}) ]]; then
        LD_LIBRARY_PATH=$(echo ${LD_LIBRARY_PATH} | sed "s/${V6LS}//g")
    fi

    if [[ -n $(echo ${LD_LIBRARY_PATH} | grep ${V8L}) ]]; then
        LD_LIBRARY_PATH=$(echo ${LD_LIBRARY_PATH} | sed "s/${V8LS}//g")
    fi
}

_add_46()
{
    PATH="${V6G}:${PATH}"
    LD_LIBRARY_PATH="${V6L}:${LD_LIBRARY_PATH}"
}

_add_48()
{
    PATH="${V8G}:${PATH}"
    LD_LIBRARY_PATH="${V8L}:${LD_LIBRARY_PATH}"
}

################################################################################
## MAIN
################################################################################
mode='SWITCH'
targetVer=''
while (( $# ))
do
    if [[ $1 == '-s' ]]; then
        mode='SWITCH'
    elif [[ $1 == '-a' ]]; then
        mode='ADD'
    elif [[ $1 == '46' ]]; then
        targetVer='46'
    elif [[ $1 == '48' ]]; then
        targetVer='48'
    elif [[ $1 == 'org' ]]; then
        targetVer=''
    fi

    shift
done

if [[ $mode = 'SWITCH' ]]; then
    _clean_gcc_in_path
fi

if [[ -n $targetVer ]]; then
    _add_$targetVer 
fi

PATH=$(echo ${PATH} | sed 's/::/:/g')
PATH=${PATH#:}
PATH=${PATH%:}
export PATH

LD_LIBRARY_PATH=$(echo ${LD_LIBRARY_PATH} | sed 's/::/:/g')
LD_LIBRARY_PATH=${LD_LIBRARY_PATH#:}
LD_LIBRARY_PATH=${LD_LIBRARY_PATH%:}
export LD_LIBRARY_PATH

echo ""
echo "######################################################################"
echo "######################################################################"
echo "PATH: "
echo $PATH
echo ""
echo "######################################################################"
echo "######################################################################"
echo "LD_LIBRARY_PATH: "
echo $LD_LIBRARY_PATH
echo ""
