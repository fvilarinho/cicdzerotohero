#!/bin/bash

# Gets a credential value.
function getCredential() {
  if [ -f "$CREDENTIALS_FILENAME" ]; then
    value=$(awk -F'=' '/'$1'/,/^\s*$/{ if($1~/'$2'/) { print substr($0, length($1) + 2) } }' "$CREDENTIALS_FILENAME" | tr -d '"' | tr -d ' ')
  else
    value=
  fi

  echo "$value"
}

# Prepare the environment to execute this script.
function prepareToExecute() {
  export DOCKER_CMD=$(which docker)
  export TERRAFORM_CMD=$(which terraform)

  export WORK_DIR="$PWD"/iac
  export CREDENTIALS_FILENAME="$WORK_DIR"/.credentials
  export BUILD_ENV_FILENAME="$WORK_DIR"/.env

  source "$BUILD_ENV_FILENAME"

  if [ -f "$CREDENTIALS_FILENAME" ]; then
    export EDGEGRID_ACCOUNT_KEY=$(getCredential "edgegrid" "account_key")
    export EDGEGRID_HOST=$(getCredential "edgegrid" "host")
    export EDGEGRID_ACCESS_TOKEN=$(getCredential "edgegrid" "access_token")
    export EDGEGRID_CLIENT_TOKEN=$(getCredential "edgegrid" "client_token")
    export EDGEGRID_CLIENT_SECRET=$(getCredential "edgegrid" "client_secret")
    export ACC_TOKEN=$(getCredential "linode" "token")
  fi
}

# Show banner.
function showBanner() {
  # Check if the banner file exists.
  if [ -f banner.txt ]; then
    cat banner.txt
  fi
}

prepareToExecute