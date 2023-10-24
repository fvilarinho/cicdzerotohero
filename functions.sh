#!/bin/bash

# Check the dependencies to run this scripts.
function checkDependencies() {
  export DOCKER_CMD=$(which docker)

  if [ -z "$DOCKER_CMD" ]; then
    echo "Docker is not installed! Please install it first to continue!"

    exit 1
  fi

  export TERRAFORM_CMD=$(which terraform)

  if [ -z "$TERRAFORM_CMD" ]; then
    echo "Terraform is not installed! Please install it first to continue!"

    exit 1
  fi
}

# Show banner.
function showBanner() {
  # Check if the banner file exists.
  if [ -f banner.txt ]; then
    cat banner.txt
  fi
}