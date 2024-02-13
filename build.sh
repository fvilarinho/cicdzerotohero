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

# Build the container images.
function build() {
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