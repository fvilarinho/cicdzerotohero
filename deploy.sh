#!/bin/bash

function prepareToExecute() {
  source functions.sh

  showBanner
}

function deploy() {
  cd iac || exit 1

  $TERRAFORM_CMD init \
                 -upgrade \
                 -migrate-state

  $TERRAFORM_CMD plan \
                 -compact-warnings \
                 -target=module.stackscript

  $TERRAFORM_CMD apply \
                 -compact-warnings \
                 -target=module.stackscript \
                 -auto-approve
}

function main() {
  prepareToExecute
  checkDependencies
  deploy
}

main