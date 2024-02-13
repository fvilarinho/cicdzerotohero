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

# Publishes the container images in the container registry.
function publish() {
  # Authenticate in the container registry.
  echo "$DOCKER_REGISTRY_PASSWORD" | $DOCKER_CMD login -u "$DOCKER_REGISTRY_ID" "$DOCKER_REGISTRY_URL" --password-stdin || exit 1

  $DOCKER_CMD compose push
}

# Main function.
function main() {
  prepareToExecute
  checkDependencies
  publish
}

main