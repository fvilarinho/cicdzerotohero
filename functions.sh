#!/bin/bash

# Shows the labels.
function showLabel() {
  if [[ "$0" == *"build.sh"* ]]; then
    echo "** Build **"
  elif [[ "$0" == *"undeploy.sh"* ]]; then
    echo "** Undeploy **"
  elif [[ "$0" == *"deploy.sh"* ]]; then
    echo "** Deploy **"
  fi

  echo
}

# Prepares the environment to execute this script.
function prepareToExecute() {
  # Required environment variables.
  export WORK_DIR=$(pwd)
  export BUILD_ENVIRONMENT_FILENAME=$WORK_DIR/.env

  if [ -e "$BUILD_ENVIRONMENT_FILENAME" ]; then
    source "$BUILD_ENVIRONMENT_FILENAME"
  fi

  # Required binaries.
  export TERRAFORM_CMD=$(which terraform)
  export DOCKER_CMD=$(which docker)
  export CERTBOT_CMD=$(which certbot)
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