#!/bin/bash

_main()
{
    local inputDirRoot="${HOME}/Downloads"
    builtin cd $inputDirRoot
    local dirsToDo=$(find . -name "*" -type d | grep -v '^\.$' | grep -v '\$RECYCLE.BIN' | sort | cut -c 3- )
    for d in $dirsToDo
    do
        echo $d
        cd $d
        chmod 644 ./*
        local totalNum=$(ls | wc -w)
        local index=0
        for fileNameOrg in $(ls | sort)
        do
            fileNameExt=${fileNameOrg##*.}
            fileNameExt=$(echo ${fileNameExt} | tr '[:upper:]' '[:lower:]')

            local fileNameNew=$( printf "%s-%03d.%s" $d $(( $totalNum - $index )) $fileNameExt )
            echo "mv $fileNameOrg $fileNameNew"
            mv $fileNameOrg $fileNameNew
            index=$(( $index + 1 ))
        done
        cd -
    done
}

_main "$@"
