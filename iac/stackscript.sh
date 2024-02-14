#!/bin/bash
# <UDF name="HOSTNAME" Label="Compute Hostname" example="Hostname of the Compute instance."/>
# <UDF name="PRIVATE_KEY" Label="Compute SSH Private Key" default=""/>
# <UDF name="EDGEGRID_ACCOUNT_KEY" Label="Akamai EdgeGrid Account Key" example="Akamai Account Key to be used in APIs/CLI/Terraform calls." default=""/>
# <UDF name="EDGEGRID_HOST" Label="Akamai EdgeGrid Hostname" example="Hostname used to authenticate the APIs/CLI/Terraform calls, using the Akamai EdgeGrid."/>
# <UDF name="EDGEGRID_ACCESS_TOKEN" Label="Akamai EdgeGrid Access Token" example="Access Token used to authenticate the APIs/CLI/Terraform calls, using the Akamai EdgeGrid."/>
# <UDF name="EDGEGRID_CLIENT_TOKEN" Label="Akamai EdgeGrid Client Token" example="Client Token used to authenticate the APIs/CLI/Terraform calls, using the Akamai EdgeGrid."/>
# <UDF name="EDGEGRID_CLIENT_SECRET" Label="Akamai EdgeGrid Client Secret" example="Client Secret used to authenticate the APIs/CLI/Terraform calls, using the Akamai EdgeGrid."/>
# <UDF name="ACC_TOKEN" Label="Akamai Connected Cloud Token" example="Token used to authenticate the APIs/CLI/Terraform calls in the Akamai Connected Cloud."/>
# <UDF name="ACC_ACCESS_KEY" Label="Akamai Connected Cloud Access Key" example="Access Key used to authenticate in Akamai Connected Cloud Object Storage, used for Terraform State Management."/>
# <UDF name="ACC_SECRET_KEY" Label="Akamai Connected Cloud Secret Key" example="Access Key used to authenticate in Akamai Connected Cloud Object Storage, used for Terraform State Management."/>

# Prepares the environment to execute this script.
function prepareToExecute() {
  # Required environment variables.
  export EDGEGRID_CREDENTIALS_FILENAME=/root/.edgerc
  export ACC_CREDENTIALS_DIR=/root/.aws
  export ACC_CREDENTIALS_FILENAME=/root/.aws/credentials

  setHostname
  createPrivateKeyFile
}

# Creates the SSH private key.
function createPrivateKeyFile() {
  echo "Creating SSH private key..." > /dev/ttyS0
  mkdir -p /root/.ssh

  if [ -n "$PRIVATE_KEY" ]; then
    echo "$PRIVATE_KEY" > /root/.ssh/id_rsa
  else
    ssh-keygen -b 4096 -t rsa -f /root/.ssh/id_rsa -q -N ""
  fi
}

# Creates the Akamai EdgeGrid credentials file.
function createEdgeGridCredentialsFile() {
  echo "[default]" > "$EDGEGRID_CREDENTIALS_FILENAME"

  # Checks if the account key was defined.
  if [ -n "$EDGEGRID_ACCOUNT_KEY" ]; then
    echo "account_key   = $EDGEGRID_ACCOUNT_KEY" >> "$EDGEGRID_CREDENTIALS_FILENAME"
  fi

  echo "client_secret = $EDGEGRID_CLIENT_SECRET" >> "$EDGEGRID_CREDENTIALS_FILENAME"
  echo "host          = $EDGEGRID_HOST" >> "$EDGEGRID_CREDENTIALS_FILENAME"
  echo "access_token  = $EDGEGRID_ACCESS_TOKEN" >> "$EDGEGRID_CREDENTIALS_FILENAME"
  echo "client_token  = $EDGEGRID_CLIENT_TOKEN" >> "$EDGEGRID_CREDENTIALS_FILENAME"
}

# Creates the Akamai Connected Cloud credentials file.
function createAccCredentialsFile() {
  # Creates the directory if does not exist.
  mkdir -p "$ACC_CREDENTIALS_DIR"

  echo "[default]" > "$ACC_CREDENTIALS_FILENAME"
  echo "token                 = $ACC_TOKEN" >> "$ACC_CREDENTIALS_FILENAME"
  echo "aws_access_key_id     = $ACC_ACCESS_KEY" >> "$ACC_CREDENTIALS_FILENAME"
  echo "aws_secret_access_key = $ACC_SECRET_KEY" >> "$ACC_CREDENTIALS_FILENAME"
}

# Defines the hostname.
function setHostname() {
  echo "Setting the hostname..." > /dev/ttyS0

  hostnamectl set-hostname "$HOSTNAME"
}

# Updates the system with all required software and files.
function updateSystem() {
  echo "Updating the system..." > /dev/ttyS0

  # Avoid human interaction.
  export DEBIAN_FRONTEND=noninteractive

  # Update the packages repositories.
  apt update

  # Update the system.
  apt -y upgrade

  installRequiredSoftware
}

# Installs the required software.
function installRequiredSoftware() {
  echo "Installing required software..." > /dev/ttyS0

  # Avoid human interaction.
  export DEBIAN_FRONTEND=noninteractive

  # Install required binaries.
  apt -y install ca-certificates \
                 gnupg2 \
                 curl \
                 wget \
                 vim \
                 unzip \
                 git

  # Required binaries environment variables.
  export CURL_CMD=$(which curl)
  export WGET_CMD=$(which wget)
  export GPG_CMD=$(which gpg)
  export GIT_CMD=$(which git)
  export UNZIP_CMD=$(which unzip)

  installDocker
  installCiCd
}

# Installs Docker.
function installDocker() {
  echo "Installing Docker..." > /dev/ttyS0

  # Downloads Docker installation script.
  $CURL_CMD https://get.docker.com | sh -

  # Enables it in boot.
  systemctl enable docker

  export DOCKER_CMD=$(which docker)
}

# Installs the CI/CD (Gitea and Jenkins).
function installCiCd() {
  echo "Installing CI/CD..." > /dev/ttyS0

  # Downloads the CI/CD repository.
  $GIT_CMD clone https://github.com/fvilarinho/cicdzerotohero /root/cicdzerotohero

  cd /root/cicdzerotohero || exit 1

  # Gives permission to execute.
  chmod +x *.sh

  # Clean-up.
  rm -rf .git
  rm -f .gitignore
}

# Starts the CI/CD (Gitea and Jenkins).
function startCiCd() {
  echo "Starting CI/CD..." > /dev/ttyS0

  createEdgeGridCredentialsFile
  createAccCredentialsFile

  cd /root/cicdzerotohero || exit 1

  ./start.sh

  c=0

  # Waits until the stack is up and running.
  while true; do
    containerId=$($DOCKER_CMD ps | grep jenkins | awk '{print $1}')

    # Checks if Jenkins is up and running.
    if [ -n "$containerId" ]; then
      while true; do
        # Gets the initial administration password.
        $DOCKER_CMD cp "$containerId":/var/jenkins_home/secrets/initialAdminPassword /root/cicdzerotohero/initialAdminPassword

        if [ -f /root/cicdzerotohero/initialAdminPassword ]; then
          echo > /dev/ttyS0
          echo "Jenkins initial password is: " > /dev/ttyS0

          cat /root/cicdzerotohero/initialAdminPassword > /dev/ttyS0

          break
        else
          if [ $c -eq 0 ]; then
            echo "Waiting for CI/CD boot..." > /dev/ttyS0

            c=1
          fi

          sleep 1
        fi
      done

      break
    else
      if [ $c -eq 0 ]; then
        echo "Waiting for CI/CD boot..." > /dev/ttyS0

        c=1
      fi

      sleep 1
    fi
  done

  echo > /dev/ttyS0
  echo "Continue the setup in the Jenkins UI!" > /dev/ttyS0
  echo > /dev/ttyS0
  echo "Add the SSH public key in Gitea!" > /dev/ttyS0

  if [ -f /root/.ssh/id_rsa.pub ]; then
    cat /root/.ssh/id_rsa.pub > /dev/ttyS0
  else
    cat /root/.ssh/authorized_keys > /dev/ttyS0
  fi

  echo > /dev/ttyS0

  # Gets the compute instance IP.
  ip=$($CURL_CMD ipinfo.io/ip)

  echo "Edit your hosts file and add the following lines:" > /dev/ttyS0
  echo "$ip gitea.localdomain" > /dev/ttyS0
  echo "$ip jenkins.localdomain" > /dev/ttyS0

  echo > /dev/ttyS0

  echo "Then" > /dev/ttyS0

  echo > /dev/ttyS0

  echo "For Gitea, browse https://gitea.localdomain" > /dev/ttyS0
  echo "For Jenkins, browse https://jenkins.localdomain" > /dev/ttyS0
}

# Main function.
function main() {
  prepareToExecute
  updateSystem
  startCiCd
}

main