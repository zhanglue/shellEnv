#!/bin/bash

################################################################################
## Feature  : Swicth git.
## Author   : zhanglue
## Date     : 2017.08.08
################################################################################

: ${GIT_13:='/home/zhanglue/tools/git-2.13.0/bin'}
GIT_13S=$( echo $GIT_13 | sed 's,/,\\/,g')

curVersion=$( git --version )
if [[ $curVersion == 'git version 2.11.0' ]]; then
    if [[ -z $(echo ${PATH} | grep ${GIT_13}) ]]; then
        PATH="${GIT_13}:${PATH}"
    fi
elif [[ $curVersion == 'git version 2.13.0' ]]; then
    PATH=$(echo ${PATH} | sed "s/${GIT_13S}//g")
fi

PATH=$(echo ${PATH} | sed 's/::/:/g')
PATH=${PATH#:}
PATH=${PATH%:}
export PATH

git --version
