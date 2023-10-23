#!/bin/bash

# Prepares the environment to execute this script.
function prepareToExecute() {
  # Loads utility functions.
  source functions.sh

  showBanner
}

# Undeploys the provisioned infrastructure.
function undeploy() {
  cd iac || exit 1

  # Initializes Terraform providers and state.
  $TERRAFORM_CMD init \
                 -upgrade \
                 -migrate-state

  # Destroys the provisioned infrastructure.
  $TERRAFORM_CMD destroy \
                 -compact-warnings \
                 -auto-approve \
                 -target=module.provisioning \
                 -var "edgeGridAccountKey=$EDGEGRID_ACCOUNT_KEY" \
                 -var "edgeGridHost=$EDGEGRID_HOST" \
                 -var "edgeGridAccessToken=$EDGEGRID_ACCESS_TOKEN" \
                 -var "edgeGridClientToken=$EDGEGRID_CLIENT_TOKEN" \
                 -var "edgeGridClientSecret=$EDGEGRID_CLIENT_SECRET" \
                 -var "accToken=$ACC_TOKEN"
}

# Main function.
function main() {
  prepareToExecute
  checkDependencies
  undeploy
}

main