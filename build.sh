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

  cd iac || exit 1

  source .env
}

# Builds the container images.
function build() {

  $DOCKER_CMD build -t "$DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_ID/gitea-runner:$BUILD_VERSION" .
}

# Main function.
function main() {
  prepareToExecute
  checkDependencies
  build
}

main