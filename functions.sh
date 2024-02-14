#!/bin/bash

# Shows the labels.
function showLabel() {
  if [[ "$0" == *"build.sh"* ]]; then
    echo "** Build/Package **"
  elif [[ "$0" == *"publish.sh"* ]]; then
    echo "** Publish **"
  elif [[ "$0" == *"start.sh"* ]]; then
    echo "** Start **"
  elif [[ "$0" == *"stop.sh"* ]]; then
    echo "** Stop **"
  elif [[ "$0" == *"reload.sh"* ]]; then
    echo "** Reload **"
  elif [[ "$0" == *"undeploy.sh"* ]]; then
    echo "** Undeploy **"
  elif [[ "$0" == *"deploy.sh"* ]]; then
    echo "** Deploy **"
  fi

  echo
}

# Gets a credential value.
function getCredential() {
  if [ -f "$CREDENTIALS_FILENAME" ]; then
    value=$(awk -F'=' '/'$1'/,/^\s*$/{ if($1~/'$2'/) { print substr($0, length($1) + 2) } }' "$CREDENTIALS_FILENAME" | tr -d '"' | tr -d ' ')
  else
    value=
  fi

  echo "$value"
}

# Prepares the environment to execute this script.
function prepareToExecute() {
  # Required files/paths.
  export WORK_DIR="$PWD"/iac
  export CREDENTIALS_FILENAME="$WORK_DIR"/.credentials
  export SETTINGS_FILENAME="$WORK_DIR"/settings.json
  export PRIVATE_KEY_FILENAME="$WORK_DIR"/.id_rsa
  export BUILD_ENV_FILENAME="$WORK_DIR"/.env

  # Required binaries
  export DOCKER_CMD=$(which docker)
  export TERRAFORM_CMD=$(which terraform)

  # Environment variables.
  source "$BUILD_ENV_FILENAME"

  if [ -f "$CREDENTIALS_FILENAME" ]; then
    export EDGEGRID_ACCOUNT_KEY=$(getCredential "edgegrid" "account_key")
    export EDGEGRID_HOST=$(getCredential "edgegrid" "host")
    export EDGEGRID_ACCESS_TOKEN=$(getCredential "edgegrid" "access_token")
    export EDGEGRID_CLIENT_TOKEN=$(getCredential "edgegrid" "client_token")
    export EDGEGRID_CLIENT_SECRET=$(getCredential "edgegrid" "client_secret")
    export ACC_TOKEN=$(getCredential "linode" "token")
  fi

  export TF_VAR_edgeGridAccountKey="$EDGEGRID_ACCOUNT_KEY"
  export TF_VAR_edgeGridHost="$EDGEGRID_HOST"
  export TF_VAR_edgeGridAccessToken="$EDGEGRID_ACCESS_TOKEN"
  export TF_VAR_edgeGridClientToken="$EDGEGRID_CLIENT_TOKEN"
  export TF_VAR_edgeGridClientSecret="$EDGEGRID_CLIENT_SECRET"
  export TF_VAR_accToken="$ACC_TOKEN"
  export TF_VAR_settingsFilename="$SETTINGS_FILENAME"
  export TF_VAR_privateKeyFilename="$PRIVATE_KEY_FILENAME"
}

# Shows the banner.
function showBanner() {
  # Checks if the banner file exists.
  if [ -f banner.txt ]; then
    cat banner.txt
  fi

  showLabel
}

prepareToExecute