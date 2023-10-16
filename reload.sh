#!/bin/bash

function prepareToExecute() {
  source functions.sh

  showBanner
}

function reload() {
  cd iac || exit 1

  source .env

  $DOCKER_CMD compose down
  $DOCKER_CMD compose up -d

  echo "Reloaded!"
}

function main() {
  prepareToExecute
  checkDependencies
  reload
}

main