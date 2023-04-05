#!/bin/bash

echo "This script monitors free disk space and notifies when it's below a specific value"
read -p "Please, entery minimum allowed free disk space (GB): " SPACE_TRESHOLD
SPACE_TRESHOLD=${SPACE_TRESHOLD:-50}


while :
do
    CURRENT_FREE_SPACE=$(df -bg | awk 'NR==2{print $4}')

    if (( CURRENT_FREE_SPACE < SPACE_TRESHOLD )); then
        echo "You have ${CURRENT_FREE_SPACE}GB available. You are running out of minimum allowed space - ${SPACE_TRESHOLD}GB"
        exit 1
    fi  
done
