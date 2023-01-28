#!/bin/bash

EXTS_TO_PROCESS=(jpg mov mp4 heic png dng)

_echo_info()
{
    echo "INFO: $*"
}

_echo_warning()
{
    echo "WARNING: $*"
}

_echo_error()
{
    echo "ERROR: $*"
}

_main()
{
    pathToProcess="${HOME}/Downloads"
    
    echo "Path to process: $pathToProcess"
    
    cd $pathToProcess
    
    #for fileNameOrg in $(ls -F | grep '[^@/]$')
    for fileNameOrg in $(ls)
    do
        fileNameExt=${fileNameOrg##*.}
        if [[ -z ${fileNameExt} ]]; then
            _echo_warning "File ext name unknown: ${fileNameOrg}"
            continue
        fi
    
        fileNameExt=$(echo ${fileNameExt} | tr '[:upper:]' '[:lower:]')
        if [[ ${fileNameExt} == "jpeg" ]]; then
            fileNameExt='jpg'
        fi

        processFlag=0
        for e in ${EXTS_TO_PROCESS[@]}
        do
            if [[ $e == $fileNameExt ]]; then
                processFlag=1
                break
            fi
        done
        if (( ! $processFlag )); then
            _echo_info "File skiped: $fileNameOrg"
            continue
        fi
    
        fileNamePure=${fileNameOrg%.*}
    
        echo ""
        echo "Original  : $fileNameOrg"
        echo "Pure      : $fileNamePure"
        echo "Ext       : $fileNameExt"

        crushPostIndex=2
        #dateInLinuxSecond=$(stat -f "%m" $fileNameOrg)
        #fileNamePureInDate=$(date -r ${dateInLinuxSecond} "+%Y%m%d_%H%M%S")
        fileNamePureInDate=$(stat $fileNameOrg | grep Birth | cut -d ':' -f 2- | cut -d '.' -f 1 | cut -d ' ' -f 2- | sed 's/-//g' | sed 's/://g' | sed 's/ /_/g')
        fileNameFormated="${fileNamePureInDate}.${fileNameExt}"
        echo ${fileNameFormated}
        while [[ -e $fileNameFormated ]];
        do
            fileNameFormated="${fileNamePureInDate}_${crushPostIndex}.${fileNameExt}"
            crushPostIndex=$(( $crushPostIndex + 1 ))
        done

        echo "move ${fileNameOrg} to ${fileNameFormated}"
        mv ${fileNameOrg} ${fileNameFormated}
    done
}

_main "$@"
