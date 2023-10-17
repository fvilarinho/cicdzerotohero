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
                 -target=module.provisioning \
                 -var "accToken=$ACC_TOKEN" \
                 -var "edgeGridHost=$EDGEGRID_HOST" \
                 -var "edgeGridAccessToken=$EDGEGRID_ACCESS_TOKEN" \
                 -var "edgeGridClientToken=$EDGEGRID_CLIENT_TOKEN" \
                 -var "edgeGridClientSecret=$EDGEGRID_CLIENT_SECRET"
  $TERRAFORM_CMD apply \
                 -compact-warnings \
                 -target=module.provisioning \
                 -var "accToken=$ACC_TOKEN" \
                 -var "edgeGridHost=$EDGEGRID_HOST" \
                 -var "edgeGridAccessToken=$EDGEGRID_ACCESS_TOKEN" \
                 -var "edgeGridClientToken=$EDGEGRID_CLIENT_TOKEN" \
                 -var "edgeGridClientSecret=$EDGEGRID_CLIENT_SECRET" \
                 -auto-approve
}

function main() {
  prepareToExecute
  checkDependencies
  deploy
}

main