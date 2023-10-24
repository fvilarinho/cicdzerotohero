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

# Publishes the container images in the container registry.
function publish() {
  # Authenticate in the container registry.
  echo "$DOCKER_REGISTRY_PASSWORD" | $DOCKER_CMD login -u "$DOCKER_REGISTRY_ID" "$DOCKER_REGISTRY_URL" --password-stdin || exit 1

  $DOCKER_CMD compose push

  echo "Published!"
}

# Main function.
function main() {
  prepareToExecute
  checkDependencies
  publish
}

main