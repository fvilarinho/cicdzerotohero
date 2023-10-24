#!/bin/bash

# Prepares the environment to execute this script.
function prepareToExecute() {
  # Loads utility functions.
  source functions.sh

  showBanner

  cd iac || exit 1

  # Loads the environment variables.
  source .env
}

# Stops the stack locally.
function stop() {
  $DOCKER_CMD compose down

  echo "Stopped!"
}

# Main function.
function main() {
  prepareToExecute
  checkDependencies
  stop
}

main