#!/bin/bash

# Reads the environment variables.
source .env

DOCKER_CMD=$(which docker)

# Create the persistent volume.
$DOCKER_CMD volume create gitea-runner_data

# Downloads the container image from the registry.
$DOCKER_CMD pull "$DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_ID/gitea-runner:$BUILD_VERSION"

# Stops & deletes the current running container.
$DOCKER_CMD stop gitea-runner 2>&1 /dev/null
$DOCKER_CMD rm -f gitea-runner 2>&1 /dev/null

# Starts the container with the updated image.
$DOCKER_CMD run \
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