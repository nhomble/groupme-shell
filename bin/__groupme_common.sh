#!/usr/bin/env bash

export GROUPME_CONFIG=~/.groupme-shell
export GROUPME_API_BASE=https://api.groupme.com/v3

LOG_DIR="$HOME/.local/groupme-shell"
mkdir -p "$LOG_DIR"
LOGS="$LOG_DIR/logs.txt"
echo "Start" >> "$LOGS"

function logit() {
  local message="$1"
  echo "$(date) :: $message" >> "$LOGS"
}

function hasConfig(){
    if [[ ! -e $GROUPME_CONFIG ]]; then
        printf "Configuration=$GROUPME_CONFIG does not exist.\nRun:\n\tgroupme-login\n"
        exit 1
    fi
}

# stark and wayne
function _j() {
    local input="$1"
    local cmd="echo $input | base64 --decode | jq -r $2"
    eval "$cmd"
}

function _escape () {
    echo "$@" | sed 's/"/\\"/g'
}

# expects json response in b64
function checkStatus() {
    local b64_response="$1"
    local status=""

    # base64 -i is meant to ignore garbage in coreutils
    if [[ $(isMac) != "true" ]]; then
      status=$(echo "$b64_response" \
          | base64 -i --decode \
          | jq -c '.meta.code'\
      )
    fi

    if [[ "401" == "$status" ]]; then
        printf "Token is stale, we got a 401\n"
        exit 1
    fi
}

# platform safe formatter
function dateFormat() {
  local ts="$1"
  local cmd=""
  local ret=""
  if [[ $(isMac) == "true" ]]; then
    ret="$(date -r "$ts" +'%m/%d %I:%M %p')"
  else
    ret="$(date -d @"$ts" +'%m/%d %I:%M %p')"
  fi
  echo "$ret"
}

# check if mac
function isMac() {
  if [[ $(uname) == "Darwin" ]]; then
    echo "true"
  else
    echo "false"
  fi
}
