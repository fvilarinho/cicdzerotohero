#!/bin/bash

TERRAFORM_CMD=`which terraform`

if [ ! -f "$TERRAFORM_CMD" ]; then
  echo "Terraform is not installed! Please install it first to proceed!"

  exit 1
fi

$TERRAFORM_CMD init --upgrade
$TERRAFORM_CMD plan -var "linode_token=$LINODE_TOKEN"
$TERRAFORM_CMD apply -var "linode_token=$LINODE_TOKEN" --auto-approve