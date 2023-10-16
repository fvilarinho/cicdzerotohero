#!/bin/bash

function prepareToExecute() {
  source functions.sh

  showBanner
}

function build() {
  cd iac || exit 1

  $DOCKER_CMD compose build

  echo "Built!"
}

function main() {
  prepareToExecute
  checkDependencies
  build
}

main