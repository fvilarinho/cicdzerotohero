#!/bin/bash

DOCKER_CMD=$(which docker)

if [ -z "$DOCKER_CMD" ]; then
  echo "Docker is not installed! Please install it first to continue!"

  exit 1
fi

$DOCKER_CMD compose up -d