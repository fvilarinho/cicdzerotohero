#!/bin/bash

export TERRAFORM_CMD=$(which terraform)
export TF_VAR_linodeToken="$LINODE_TOKEN"
export TF_VAR_edgeGridAccountKey="$EDGEGRID_ACCOUNT_KEY"
export TF_VAR_edgeGridHost="$EDGEGRID_HOST"
export TF_VAR_edgeGridAccessToken="$EDGEGRID_ACCESS_TOKEN"
export TF_VAR_edgeGridClientToken="$EDGEGRID_CLIENT_TOKEN"
export TF_VAR_edgeGridClientSecret="$EDGEGRID_CLIENT_SECRET"
export TF_VAR_contractId="$CONTRACT_ID"
export TF_VAR_groupId="$GROUP_ID"
export TF_VAR_notificationEmail="$NOTIFICATION_EMAIL"

$TERRAFORM_CMD init

$TERRAFORM_CMD plan -out akamai-as-code.plan

$TERRAFORM_CMD apply -auto-approve akamai-as-code.plan