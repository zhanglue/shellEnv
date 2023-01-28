#!/bin/bash

################################################################################
## Feature  : List git branch in local and checkout.
## Author   : Zhang ChunYang
## Date     : 2021.02.02
################################################################################

################################################################################
##  CHECK THE COMPLETENESS FIRST OF ALL
################################################################################
if [[ -n ${DIR_SCRIPTS} ]] ||
   [[ -s "${DIR_SCRIPTS}/common.sh" ]]
then
    COMMON_FILE="${DIR_SCRIPTS}/common.sh"
    . $COMMON_FILE
fi
################################################################################

PAGE_SIZE=10
RETRACT="  "

############################################################
##  USAGE
############################################################
_usage()
{
    local code=$1
    : ${code:=0}
    echo ""

    if [[ $code = 'help' ]]; then
        echo -e "${GRN_F}listAndEnter.sh${END_S} is used to list all directories and enter, as its name says."
        echo 'It can be executed in and only in "source".'
        echo 'Set a appropriate alias to make it easier.'
        echo
        _echo_usage
        echo 'source listAndEnter.sh [-h] [-i index] [keywords]'
        echo
        echo '[-h ]      To this manual.'
        echo '[-i index] Specify the index directly but list and choose.'
        echo '           The "index" must be a number between 0~9.'
        echo '[keywords] Filter out the directories by the keywords.'
        echo '           Multi-keywords is supported.'
        return
    fi


    if (( $code < 20 )); then
        _echo_warning
    else
        _echo_error
    fi

    case $code in
        0)
            echo "${RETRACT}I don't know what are you talking about."
            ;;
        1)
            echo "${RETRACT}Page number and index are both necessary, dear."
            ;;
        2)
            echo "${RETRACT}I don't believe that you can see the future, hehe."
            ;;
        3)
            echo "${RETRACT}Index is limited under ${PAGE_SIZE}."
            ;;
        4)
            echo "${RETRACT}There are $itemsNumTotal items totally."
            ;;
        21)
            echo "${RETRACT}Specified index is not a number or bigger than 9."
            ;;
        22)
            echo "${RETRACT}Specified index is lager than all."
            ;;
        *)
            ;;
    esac
}

################################################################################
##  MAIN
################################################################################

itemIndex=""
keyword=""
helpFlag=0
straightFlag=1
deleteFlag=0
while (( $# ))
do
    case $1 in
        -i | --index )
            shift
            itemIndex=$1
            ;;
        -h | --help )
            helpFlag=1
            RETRACT=""
            ;;
        -ns | --no-straight )
            straightFlag=0
            ;;
        -d | --delete )
            deleteFlag=1
            ;;
        *)
            if [[ -z $keyword ]]; then
                keyword=${1%/}
            else
                keyword="${keyword}|${1%/}"
            fi
            ;;
    esac
    shift
done

if (( $helpFlag )); then
    _usage 'help'
    exit 0
fi

items=( $( git branch --no-color | grep -E "$keyword" 2> /dev/null | sed 's/[\*]//g' | sed 's/\t/ /g' | sed 's/[[:space:]]\+/ /g' | sort -r ) )

if (( ${#items[@]} == 0 )); then
    echo ""
    _echo_error
    echo "${RETRACT}Nothing to do with..."
    echo ""
    exit 0
fi

if (( $deleteFlag )); then
    echo ""
    echo -e "${RETRACT}${WHT_F}${RED_B}!!!!!!!!!!!!!WARNING!!!!!!!!!!!!!!${END_S}"
    echo -e "${RETRACT}${RVT_S}${WHT_F}${RED_B}!!YOU ARE GOING TO DELETE BRANCH!!${END_S}"
    echo -e "${RETRACT}${WHT_F}${RED_B}!!!!!!!!!!!!!WARNING!!!!!!!!!!!!!!${END_S}"
    echo ""
fi

if (( ${#items[@]} == 1 )) && (( $straightFlag )); then
    itemIndex=0
elif [[ -z $itemIndex ]]; then
    _list_and_choose
else
    if [[ -z `echo $itemIndex | grep '^[[:digit:]]$'` ]]; then
        _usage 21
        itemIndex=""
    elif (( $itemIndex >= ${#items[@]} )); then
        _usage 22
        itemIndex=""
    fi
fi

if [[ -z $itemIndex ]]; then
    echo ""
    exit 0
fi

cmd="git checkout"
if (( $deleteFlag )); then
    cmd="git branch -d"
fi

echo ""
echo "${RETRACT}${cmd} ${items[$itemIndex]}"
echo ""

branchName=${items[$itemIndex]}
${cmd} $branchName
