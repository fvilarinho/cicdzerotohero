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

# Setup the environment.
function setup() {
  if [ ! -f ~/.ssh/id_rsa ]; then
    echo "Creating SSH keys pair..."

    ssh-keygen -q -N '' -f ~/.ssh/id_rsa

    chmod og+r  ~/.ssh/id_rsa
  fi

  if [ ! -f ~/.aws/credentials ] || [ ! -f ~/.edgerc ]; then
    echo "Creating credentials files..."

    $TERRAFORM_CMD init \
                   -upgrade \
                   -migrate-state > /dev/null

    $TERRAFORM_CMD plan \
                   -target=module.setup \
                   -compact-warnings \
                   -var "edgeGridAccountKey=$EDGEGRID_ACCOUNT_KEY" \
                   -var "edgeGridHost=$EDGEGRID_HOST" \
                   -var "edgeGridAccessToken=$EDGEGRID_ACCESS_TOKEN" \
                   -var "edgeGridClientToken=$EDGEGRID_CLIENT_TOKEN" \
                   -var "edgeGridClientSecret=$EDGEGRID_CLIENT_SECRET" \
                   -var "accToken=$ACC_TOKEN" > /dev/null

    $TERRAFORM_CMD apply \
                   -auto-approve \
                   -target=module.setup \
                   -compact-warnings \
                   -var "edgeGridAccountKey=$EDGEGRID_ACCOUNT_KEY" \
                   -var "edgeGridHost=$EDGEGRID_HOST" \
                   -var "edgeGridAccessToken=$EDGEGRID_ACCESS_TOKEN" \
                   -var "edgeGridClientToken=$EDGEGRID_CLIENT_TOKEN" \
                   -var "edgeGridClientSecret=$EDGEGRID_CLIENT_SECRET" \
                   -var "accToken=$ACC_TOKEN" > /dev/null
  fi
}

# Starts the stack locally.
function start() {
  $DOCKER_CMD compose up -d

  echo "Started!"
}

# Main function.
function main() {
  prepareToExecute
  checkDependencies
  setup
  start
}

main