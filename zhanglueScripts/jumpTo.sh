#!/bin/bash

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

############################################################
##  LIST AND CHOOSE
############################################################
_list_and_choose()
{
    local pageNum=0
    local itemsNumTotal=${#items[@]}
    local pageNumTotal=$(( $itemsNumTotal / $PAGE_SIZE ))
    if (( $itemsNumTotal % $PAGE_SIZE )); then
        pageNumTotal=$(( $pageNumTotal + 1 ))
    fi
    local bShow=1
    local failedTry=0
    while (( $pageNum < $pageNumTotal ))
    do
        if (( $bShow )); then
            echo 
            echo -e "${RETRACT}${WHT_F}${BLU_B}PAGE: $(( ${pageNum} + 1 ))/${pageNumTotal}${END_S}"
            echo ""
            bFlag=1
            for (( i=$(( $pageNum * $PAGE_SIZE ));           \
                i<$(( ( $pageNum + 1 ) * $PAGE_SIZE )) &&    \
                i<$itemsNumTotal;                            \
                ++i ))
            do
                (( bFlag )) && bFlag=0 || bFlag=1
                strDisplay="${RETRACT}$(( $i % $PAGE_SIZE )). ${items[$i]}"
                if (( bFlag )); then
                    strDisplay="${DRK_S}${strDisplay}${END_S}"
                fi
                echo -e "${strDisplay}"
            done
        fi
        bShow=1

        echo ""
        read -p "${RETRACT}Choose one you like: "

        case "$REPLY" in
            [[:digit:]] )
                itemIndex=$(( $REPLY + $pageNum * $PAGE_SIZE ))
                if (( $itemIndex >= $itemsNumTotal )); then
                    _usage 3
                    : $(( failedTry++ ))
                    if (( $failedTry % 3 )); then
                        bShow=0
                    fi
                    continue
                fi
                break
                ;;
            [[:digit:]][[:digit:]] | [[:digit:]][[:digit:]][[:digit:]] | \
                [[:digit:]][[:digit:]][[:digit:]][[:digit:]] )
                _usage 3
                : $(( failedTry++ ))
                if (( $failedTry % 3 )); then
                    bShow=0
                fi
                continue
                ;;
            A* | a* )
                if [[ ! "$REPLY" =~ ^[Aa][[:digit:]]+$ ]]; then
                    _usage 0
                    : $(( failedTry++ ))
                    if (( $failedTry % 3 )); then
                        bShow=0
                    fi
                    continue
                fi
                if (( ${#REPLY} < 3 )); then
                    _usage 1
                    : $(( failedTry++ ))
                    if (( $failedTry % 3 )); then
                        bShow=0
                    fi
                    continue
                fi
                specPageNum=$(( ${REPLY:1:$(( ${#REPLY} - 2 ))} - 1 ))
                if (( $specPageNum > $pageNum )); then
                    _usage 2
                    : $(( failedTry++ ))
                    if (( $failedTry % 3 )); then
                        bShow=0
                    fi
                    continue
                fi
                itemNumInPage=${REPLY:$(( ${#REPLY} - 1 ))}
                if (( $itemNumInPage >= $PAGE_SIZE )); then
                    _usage 3
                    : $(( failedTry++ ))
                    if (( $failedTry % 3 )); then
                        bShow=0
                    fi
                    continue
                fi
                itemIndex=$(( $itemNumInPage + $(( $specPageNum * $PAGE_SIZE)) ))
                if (( $itemIndex >= $itemsNumTotal )); then
                    _usage 4
                    : $(( failedTry++ ))
                    if (( $failedTry % 3 )); then
                        bShow=0
                    fi
                    continue
                fi
                break
                ;;
            Q | q | quit )
                echo ""
                echo "  3166, Bye~"
                return
                ;;
            "")
                : $((pageNum++))
                ;;
            *)
                _usage 0
                : $(( failedTry++ ))
                if (( $failedTry % 3 )); then
                    bShow=0
                fi
                continue
                ;;
        esac
    done
}

################################################################################
##  MAIN
################################################################################

itemIndex=""
keyword=""
helpFlag=0
straightFlag=1
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
        *)
            if [[ -z $keyword ]]; then
                keyword=$1
            else
                keyword="${keyword}|$1}"
            fi
            ;;
    esac
    shift
done

if (( $helpFlag )); then
    _usage 'help'
    exit 0
fi

: ${keyword:="."}
items=($(cat ${HOME}/.ssh/comments.txt | grep ${keyword}))

if (( ${#items[@]} == 0 )); then
    echo ""
    _echo_error
    echo "${RETRACT}Nothing to do with..."
    echo ""
    exit 0
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

targetIP=$(echo -e ${items[$itemIndex]} | cut -d $'\t' -f 1)
echo $targetIP

${HOME}/.ssh/login.exp $targetIP
