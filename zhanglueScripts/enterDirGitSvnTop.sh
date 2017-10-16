#!/bin/bash

################################################################################
## Feature  : Return to top of current git repository.
## Author   : ZhangLue
## Date     : 2017.04.28
################################################################################

_get_top_dir_name()
{
    local mmm=$1
    local nnn=$2

    mmm=${mmm%/}
    nnn=${nnn%/}
    mmm=${mmm#/}
    nnn=${nnn#/}
    mmm=`echo $mmm | sed 's/[/]\+/\//g'`
    nnn=`echo $nnn | sed 's/[/]\+/\//g'`

    if [[ $mmm == $nnn ]]; then
        echo $mmm | cut -d '/' -f 1
        return
    fi

    local depthM=`echo $mmm | sed 's/\//\n/g' | wc -l`
    local depthN=`echo $mmm | sed 's/\//\n/g' | wc -l`
    local maxDepth=$depthM
    if (( $depthM < $depthN )); then
        maxDepth=$depthN
    fi

    local i=1
    for (( ; i<=$maxDepth; ++i ))
    do
        if [[ `echo $mmm | sed 's/\//\n/g' | tail -n $i` != \
            `echo $nnn | sed 's/\//\n/g' | tail -n $i` ]]; then
            echo echo $nnn | sed 's/\//\n/g' | tail -n $(( $i -1 )) | head -n 1
            return
        fi
    done
}

_get_dest_path()
{
    if [[ -z `pwd | grep $repoName` ]]; then
        echo ""
        echo "Repository root path has been rename to other."
        echo""
        return
    fi

    local repoRoot=`pwd | sed "s/\(.*\/${repoName}\)\/.*/\1/g"`
    if [[ -z `echo $destDepth | grep '^[[:digit:]]\+$'` ]]; then
        destDepth=0
    fi
    : $(( destDepth++ ))

    local destPath=${repoRoot}
    if (( $destDepth > 1 )); then
        repoRef=`pwd | sed "s/\(.*${repoName}\)\(.*\)/\2/g"`
        curDepth=`echo $repoRef | sed 's/\//\n/g' | wc -l`
        if (( $curDepth < $destDepth )); then
            destPath=""
            echo ""
            echo "Current depth <= $(( $destDepth - 1))."
            echo ""
            return
        fi

        destPath="${destPath}`echo $repoRef | cut -d '/' -f 1-$destDepth`"
    fi

    if [[ $destPath == `pwd` ]]; then
        echo ""
        echo "You are already at the destination."
        echo""
        return
    fi

    if [[ -f $transFile_ED ]]; then
        echo $destPath > $transFile_ED 
    else
        builtin cd $destPath
        pwd
        ls --color
    fi
}

destDepth=$1
func=""
repoName=`\git remote -v 2> /dev/null | grep '(push)$' | sed 's/[[:space:]]\+/ /g' | cut -d ' ' -f 2`
if [[ -n $repoName ]]; then
    repoName=`basename $repoName`
else
	svnURL=`svn info 2> /dev/null | grep '^URL'`
    if [[ -n $svnURL ]]; then
        pwdDir=`pwd -P`
        repoName=`_get_top_dir_name "$svnURL" "$pwdDir"`
        if [[ -z $repoName ]]; then
            echo ""
            echo "You have done something here which I can't handle."
            echo ""
            exit 2
        fi
    fi
fi

if [[ -z $repoName ]]; then
    echo ""
    echo "Current path is not under git/svn controll."
    echo ""
    exit 1
fi

_get_dest_path
