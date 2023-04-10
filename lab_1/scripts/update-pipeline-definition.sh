#!/bin/bash

BRANCH="main"
OWNER="razumovich"
POLL_SOURCE=0
CONFIG="development"

if ! command -v jq &> /dev/null; then
    echo "jq is not found"
    exit
fi

read -p "Pipeline file: " PIPELINE_FILE

if [[ ! $PIPELINE_FILE ]]; then
    echo "Pipeline file has not be specified. Please specify one."
    exit
fi

while getopts ":b:o:p:c:" OPTIONS
do
    case $OPTIONS in
        b) BRANCH=$OPTARG ;;
        o) OWNER=$OPTARG ;;
        p) POLL_SOURCE=$OPTARG ;;
        c) CONFIG=$OPTARG ;;
        *) ;;
    esac
done

curl $PIPELINE_FILE \
    | jq 'del(.metadata)' \
    | jq '.pipeline.version +=1' \
    | jq "(.pipeline.stages[].actions[] | select(.configuration.Branch == \"{{Branch name}}\") | .configuration.Branch) |= \"$BRANCH\"" \
    | jq "(.pipeline.stages[].actions[] | select(.configuration.Owner == \"{{GitHub Owner}}\") | .configuration.Owner) |= \"$OWNER\"" \
    | jq "(.pipeline.stages[].actions[] | select(.configuration.PollForSourceChanges == \"{{PollForSourceChanges}}\") | .configuration.PollForSourceChanges) |= \"$POLL_SOURCE\"" \
    | jq "(.pipeline.stages[].actions[] | select(.configuration.EnvironmentVariables) | .configuration.EnvironmentVariables) |= fromjson" \
    | jq "(.pipeline.stages[].actions[] | select(.configuration.EnvironmentVariables) | .configuration.EnvironmentVariables[].name) |= \"${CONFIG}\"" \
    | jq "(.pipeline.stages[].actions[] | select(.configuration.EnvironmentVariables) | .configuration.EnvironmentVariables[].value) |= \"${CONFIG}\"" \
    | jq "(.pipeline.stages[].actions[] | select(.configuration.EnvironmentVariables) | .configuration.EnvironmentVariables) |= tojson" \
    > "pipeline.$(date +%F).json"

shift $(($OPTIND - 1))


