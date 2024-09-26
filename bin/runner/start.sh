#!/bin/bash

source .env

docker volume create gitea-runner_data
docker pull "$DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_ID/gitea-runner:$BUILD_VERSION"
docker run --rm \
       -d \
       --name gitea-runner \
       -v gitea-runner_data:/data \
       -v /var/run/docker.sock:/var/run/docker.sock \
       -e GITEA_INSTANCE_URL="$GITEA_INSTANCE_URL" \
       -e GITEA_RUNNER_REGISTRATION_TOKEN="$GITEA_RUNNER_REGISTRATION_TOKEN" \
       -e GITEA_RUNNER_NAME="$GITEA_RUNNER_NAME" \
       -e GITEA_RUNNER_LABELS="$GITEA_RUNNER_LABELS" \
       "$DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_ID/gitea-runner:$BUILD_VERSION"