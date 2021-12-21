#!/usr/bin/env bash

export GROUPME_CONFIG=~/.groupme-shell
export GROUPME_API_BASE=https://api.groupme.com/v3

LOG_DIR="${HOME}/.local/groupme-shell"
mkdir -p "$LOG_DIR"
LOGS="${LOG_DIR}/logs.txt"
echo "Start" >> "$LOGS"

function logit() {
  local message="$1"
  echo "$message" >> "$LOGS"
}

function hasConfig(){
    if [[ ! -e $GROUPME_CONFIG ]]; then
        printf "Configuration=$GROUPME_CONFIG does not exist.\nRun:\n\tgroupme-login\n"
        exit 1
    fi
}

# stark and wayne
function _j() {
    local cmd="echo $1 | base64 --decode | jq -r $2"
    eval $cmd
}

function _escape () {
    echo "$@" | sed 's/"/\\"/g'
}

# expects json response in b64
function checkStatus() {
    local b64_response=$1
    local status=$(echo "$b64_response" \
        | base64 -i --decode \
        | jq -c '.meta.code'\
    )
    if [[ "401" == "$status" ]]; then
        printf "Token is stale, we got a 401\n"
        exit 1
    fi
}
