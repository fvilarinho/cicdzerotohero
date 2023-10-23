#!/bin/bash

# Prepares the environment to execute this script.
function prepareToExecute() {
  # Loads utility functions.
  source functions.sh

  showBanner
}

# Build the container images.
function build() {
  cd iac || exit 1

  $DOCKER_CMD compose build

  echo "Built!"
}

# Main function.
function main() {
  prepareToExecute
  checkDependencies
  build
}

main