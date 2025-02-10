#!/bin/bash

# Reads the environment variables.
source .env

# Create the persistent volume.
docker volume create gitea-runner_data

# Download the container image from the registry.
docker pull "$DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_ID/gitea-runner:$BUILD_VERSION"

docker stop gitea-runner

docker rm gitea-runner

# Start the container image.
docker run --rm \
       -d \
       --privileged \
       --name gitea-runner \
       -v gitea-runner_data:/data \
       -v /var/run/docker.sock:/var/run/docker.sock \
       -e GITEA_INSTANCE_URL="$GITEA_INSTANCE_URL" \
       -e GITEA_RUNNER_REGISTRATION_TOKEN="$GITEA_RUNNER_REGISTRATION_TOKEN" \
       -e GITEA_RUNNER_NAME="$GITEA_RUNNER_NAME" \
       -e GITEA_RUNNER_LABELS="$GITEA_RUNNER_LABELS" \
       "$DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_ID/gitea-runner:$BUILD_VERSION"