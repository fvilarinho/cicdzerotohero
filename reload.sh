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

# Reloads the stack.
function reload() {
  $DOCKER_CMD compose down
  $DOCKER_CMD compose up -d
}

# Main function.
function main() {
  prepareToExecute
  checkDependencies
  reload
}

main