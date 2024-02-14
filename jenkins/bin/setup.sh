#!/bin/bash

# Clean-up.
rm -f /var/jenkins_home/.ssh/known_hosts*

# Establishes the SSH connection to gitea host.
ssh git@"$GITEA_HOST"