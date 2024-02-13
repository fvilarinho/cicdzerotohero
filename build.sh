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
  # Loads utility functions.
  source functions.sh

  showBanner

  cd iac || exit 1
}

# Build the container images.
function build() {
  $DOCKER_CMD compose build
}

# Main function.
function main() {
  prepareToExecute
  checkDependencies
  build
}

main