#!/bin/bash

TERRAFORM_CMD=$(which terraform)

if [ ! -f "$TERRAFORM_CMD" ]; then
  echo "Terraform is not installed! Please install it first to proceed!"

  exit 1
fi

cd iac || exit 1

$TERRAFORM_CMD init --upgrade
$TERRAFORM_CMD plan
$TERRAFORM_CMD apply --auto-approve