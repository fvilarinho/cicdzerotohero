#!/bin/bash

function prepareToExecute() {
  source functions.sh

  showBanner
}

function publish() {
  cd iac || exit 1

  source .env

  echo "$DOCKER_REGISTRY_PASSWORD" | $DOCKER_CMD login -u "$DOCKER_REGISTRY_ID" "$DOCKER_REGISTRY_URL" --password-stdin || exit 1

  $DOCKER_CMD compose push

  echo "Published!"
}

function main() {
  prepareToExecute
  checkDependencies
  publish
}

main