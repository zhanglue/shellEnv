#!/bin/sh

if [[ $# != 1 ]]; then
    echo "keep_awake.sh [1/0]"
    exit 1
fi

if [[ $1 == 1 ]]; then
    sudo pmset -b sleep 0; sudo pmset -b disablesleep 1
    echo "KEEP AWAKE!~"
elif [[ $1 == 0 ]]; then
    sudo pmset -b sleep 5; sudo pmset -b disablesleep 0
    echo "SLEEP SLEEP!~"
else
    echo "keep_awake.sh [1/0]"
fi
