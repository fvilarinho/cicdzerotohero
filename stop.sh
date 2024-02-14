#!/bin/bash

# Checks the dependencies to run this scripts.
function checkDependencies() {
  if [ -z "$DOCKER_CMD" ]; then
    echo "Docker is not installed! Please install it first to continue!"

    exit 1
  fi
}

# Prepares the environment to execute this script.
function prepareToExecute() {
  source functions.sh

  showBanner

  cd iac || exit 1
}

# Stops the stack.
function stop() {
  $DOCKER_CMD compose down
}

# Main function.
function main() {
  prepareToExecute
  checkDependencies
  stop
}

main