#!/bin/bash

# Check the dependencies to run this scripts.
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
}

# Builds the stack.
function build() {
  export COMPOSE_BAKE=true

  $DOCKER_CMD compose build
}

# Main function.
function main() {
  prepareToExecute
  checkDependencies
  build
}

main