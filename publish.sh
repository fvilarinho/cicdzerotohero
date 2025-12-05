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
}

# Publishes the stack in the container registry.
function publish() {
  # Authentication in the container registry.
  echo "$DOCKER_REGISTRY_PASSWORD" | $DOCKER_CMD login -u "$DOCKER_REGISTRY_ID" "$DOCKER_REGISTRY_URL" --password-stdin || exit 1

  $DOCKER_CMD buildx bake --push

  export BUILD_VERSION=latest

  $DOCKER_CMD buildx bake --push
}

# Main function.
function main() {
  prepareToExecute
  checkDependencies
  publish
}

main