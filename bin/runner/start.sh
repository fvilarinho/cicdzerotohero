#!/bin/bash

source .env

docker volume create gitea-runner_data
docker run --rm \
       -d \
       --name gitea-runner \
       -v gitea-runner_data:/data \
       -v /var/run/docker.sock:/var/run/docker.sock \
       -e GITEA_INSTANCE_URL="$GITEA_INSTANCE_URL" \
       -e GITEA_RUNNER_REGISTRATION_TOKEN="$GITEA_RUNNER_REGISTRATION_TOKEN" \
       -e GITEA_RUNNER_NAME="$GITEA_RUNNER_NAME" \
       -e GITEA_RUNNER_LABELS="$GITEA_RUNNER_LABELS" \
       gitea/act_runner:latest