#!/bin/bash

# Prepares the environment to execute this script.
function prepareToExecute() {
  # Loads utility functions.
  source functions.sh

  showBanner
}

# Starts the stack locally.
function start() {
  cd iac || exit 1

  # Loads the environment variables.
  source .env

  $DOCKER_CMD compose up -d

  echo "Started!"
}

# Main function.
function main() {
  prepareToExecute
  checkDependencies
  createSshKeys
  start
}

main