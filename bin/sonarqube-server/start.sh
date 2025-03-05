#!/bin/bash

# Reads the environment variables.
source .env

DOCKER_CMD=$(which docker)

# Downloads the container images from the registry.
$DOCKER_CMD compose pull

# Starts the stack.
$DOCKER_CMD compose up -d