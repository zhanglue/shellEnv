#!/bin/bash

################################################################################
## Feature  : Kill all but current bash.
## Author   : ZhangLue
## Date     : 2017.06.29
################################################################################

curPIDs=( $( ps | grep '^[ ]\?[0-9].*bash$' | sed 's/^[ ]\+//g' | cut -d ' ' -f 1 ) )
allPIDs="$( ps aux | grep ^$USER | grep -v 'sshd:' | sed 's/[ ]\+/ /g' | cut -d ' ' -f 2 )"

for one in ${curPIDs[@]}
do
    allPIDs=$(echo $allPIDs | sed "s/\(^$one[ ]\|[ ]$one$\|[ ]$one[ ]\)/ /g")
done

#echo ${curPIDs[@]}
#echo $allPIDs
kill -9 $allPIDs
