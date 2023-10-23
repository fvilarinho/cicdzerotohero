#!/bin/bash

function prepareToExecute() {
  source functions.sh

  showBanner
}

function setup() {
  cd iac || exit 1

  terraform init \
            -upgrade \
            -migrate-state > /dev/ttyS0

  echo $? > /dev/ttyS0

  terraform plan \
            -target=module.setup \
            -compact-warnings \
            -var "edgeGridAccountKey=$EDGEGRID_ACCOUNT_KEY" \
            -var "edgeGridHost=$EDGEGRID_HOST" \
            -var "edgeGridAccessToken=$EDGEGRID_ACCESS_TOKEN" \
            -var "edgeGridClientToken=$EDGEGRID_CLIENT_TOKEN" \
            -var "edgeGridClientSecret=$EDGEGRID_CLIENT_SECRET" \
            -var "accToken=$ACC_TOKEN" \
            -var "remoteBackendId=$REMOTEBACKEND_ID" \
            -var "remoteBackendRegion=$REMOTEBACKEND_REGION" > /dev/ttyS0

  terraform apply \
            -auto-approve \
            -target=module.setup \
            -compact-warnings \
            -var "edgeGridAccountKey=$EDGEGRID_ACCOUNT_KEY" \
            -var "edgeGridHost=$EDGEGRID_HOST" \
            -var "edgeGridAccessToken=$EDGEGRID_ACCESS_TOKEN" \
            -var "edgeGridClientToken=$EDGEGRID_CLIENT_TOKEN" \
            -var "edgeGridClientSecret=$EDGEGRID_CLIENT_SECRET" \
            -var "accToken=$ACC_TOKEN" \
            -var "remoteBackendId=$REMOTEBACKEND_ID" \
            -var "remoteBackendRegion=$REMOTEBACKEND_REGION" > /dev/ttyS0
}

function main() {
  prepareToExecute
  checkDependencies
  setup
}

main