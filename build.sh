#!/bin/bash

function prepareToExecute() {
  source functions.sh

  showBanner
}

function createSshKeys() {
  cleanUp

  ssh-keygen -q -N '' -f ./id_rsa
}

function cleanUp() {
  rm -f ./id_rsa*
}

function build() {
  cd iac || exit 1

  createSshKeys

  $DOCKER_CMD compose build

  cleanUp

  echo "Built!"
}

function main() {
  prepareToExecute
  checkDependencies
  build
}

main