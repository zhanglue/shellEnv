#!/bin/bash

################################################################################
## Feature  : Bakup current 'add'/'modified' file.
## Author   : Zhang ChunYang
## Date     : 2017.06.20
################################################################################

keyword=$1
allFiles=(`\svn st 2>/dev/null | grep ^[AM] | sort | sed 's/[AM][ ]\+\([^ ]\+\)/\1/g'`)

#targetDirName=$(date +${keyword}_%Y_%m_%d_%l_%M_%S | sed 's/[ ]/0/g')
targetDirName=${keyword}
mkdir $targetDirName
restoreSH="${targetDirName}/restore.sh"
touch $restoreSH
chmod 744 $restoreSH
for one in ${allFiles[@]}
do

    echo $one
    if [[ -d $one ]]; then
        echo "mkdir -P $one" >> $restoreSH
        continue
    fi

    cp $one $targetDirName
    echo "cp `basename $one` ../$one" >> $restoreSH

done

echo 'done'
