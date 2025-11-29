#!/bin/bash

# Shows the labels.
function showLabel() {
  if [[ "$0" == *"build.sh"* ]]; then
    echo "** Build **"
  elif [[ "$0" == *"publish.sh"* ]]; then
    echo "** Publish **"
  elif [[ "$0" == *"start.sh"* ]]; then
    echo "** Start **"
  elif [[ "$0" == *"stop.sh"* ]]; then
    echo "** Stop **"
  fi

  echo
}

# Prepares the environment to execute this script.
function prepareToExecute() {
  # Required environment variables.
  export WORK_DIR=$(pwd)
  export ENVIRONMENT_FILENAME=$WORK_DIR/.env

  if [ -e "$ENVIRONMENT_FILENAME" ]; then
    source "$ENVIRONMENT_FILENAME"
  fi

  # Required binaries.
  export DOCKER_CMD=$(which docker)
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