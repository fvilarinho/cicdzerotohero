#!/bin/bash

# Prepare the environment to execute this script.
function prepareToExecute() {
  export DOCKER_CMD=$(which docker)
  export TERRAFORM_CMD=$(which terraform)
}

# Show banner.
function showBanner() {
  # Check if the banner file exists.
  if [ -f banner.txt ]; then
    cat banner.txt
  fi
}

prepareToExecute