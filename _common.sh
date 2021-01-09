#!/usr/bin/env bash

GROUPME_CONFIG=~/.groupme-shell
GROUPME_API_BASE=https://api.groupme.com/v3

function hasConfig(){
    if [[ ! -e $GROUPME_CONFIG ]]; then
        printf "Configuration=$GROUPME_CONFIG does not exist, did you groupme-login?\n"
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
