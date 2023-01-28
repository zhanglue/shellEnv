#!/bin/bash

################################################################################
## Feature  : Compress git history to recycle garbage.
## Author   : zhanglue
## Date     : 2018.01.02
################################################################################

cat log.data | sort -k 3 -g | tail -100 | cut -d ' ' -f 1 > ttt.data

cat ttt.data | while read line
do
    fileName=$(git rev-list --objects --all | grep $line | cut -d ' ' -f 2)
    echo $fileName
    command="git filter-branch --index-filter 'git rm --cached --ignore-unmatch $fileName'"
    echo $command
    $command
    #break
done

git reflog expire --expire=now --all
git fsck --full --unreachable
git repack -A -d
git gc --aggressive --prune=now
#git push --force #watch here [remote] master
