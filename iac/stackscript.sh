#!/bin/bash
# <UDF name="EDGEGRID_HOST" Label="Akamai EdgeGrid Hostname" example="Hostname used to authenticate in Akamai Intelligent Platform using APIs/CLI or Terraform calls."/>
# <UDF name="EDGEGRID_ACCESS_TOKEN" Label="Akamai EdgeGrid Access Token" example="Access Token used to authenticate in Akamai Intelligent Platform using APIs/CLI or Terraform calls."/>
# <UDF name="EDGEGRID_CLIENT_TOKEN" Label="Akamai EdgeGrid Client Token" example="Client Token used to authenticate in Akamai Intelligent Platform using APIs/CLI or Terraform calls."/>
# <UDF name="EDGEGRID_CLIENT_SECRET" Label="Akamai EdgeGrid Client Secret" example="Client Secret used to authenticate in Akamai Intelligent Platform using APIs/CLI or Terraform calls."/>
# <UDF name="ACC_ACCESS_KEY" Label="Akamai Connected Cloud Access Key" example="Access Key used to store the Terraform State Files in Akamai Connected Cloud Object Storage." default=""/>
# <UDF name="ACC_SECRET_KEY" Label="Akamai Connected Cloud Secret Key" example="Secret Key used to store the Terraform State Files in Akamai Connected Cloud Object Storage." default=""/>

function updateSystem() {
  apt update > /dev/ttyS0
  apt -y upgrade > /dev/ttyS0
}

function installRequiredSoftware() {
  # Install basic packages.
  apt -y install ca-certificates \
                 curl \
                 wget \
                 dnsutils \
                 net-tools \
                 vim \
                 gnupg2 \
                 sqlite3 \
                 git \
                 unzip \
                 htop > /dev/ttys0

  # Install Terraform.
  wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/ttyS0
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
  apt update
  apt -y install terraform > /dev/ttyS0

  # Install Akamai CLI.
  wget https://github.com/akamai/cli/releases/download/v1.5.5/akamai-v1.5.5-linuxamd64 -o /usr/bin/akamai
  chmod +x /usr/bin/akamai

  # Install Akamai Powershell.
  wget https://github.com/PowerShell/PowerShell/releases/download/v7.3.8/powershell-7.3.8-linux-x64.tar.gz -o /tmp/powershell-7.3.8-linux-x64.tar.gz
  mkdir /opt/powershell
  mv /tmp/powershell-7.3.8-linux-x64.tar.gz /opt/powershell
  cd /opt/powershell || exit 1
  tar xvzf powershell-7.3.8-linux-x64.tar.gz
}

function installProject() {
  mkdir /root/.aws
  git clone https://github.com/fvilarinho/cicdzerotohero /root/cicdzerotohero > /dev/ttyS0
  cd /root/cicdzerotohero || exit 1
  mv iac/docker-compose.yml .
  rm -rf .git
  rm -rf iac
  rm -f *.sh
  rm -f *.txt
  rm -f LICENSE
  rm -f *.md
  rm .gitignore
}

function createEdgeGridFile() {
  echo "[default]" > /root/.edgerc
  echo "host = $EDGEGRID_HOST" >> /root/.edgerc
  echo "access_token = $EDGEGRID_ACCESS_TOKEN" >> /root/.edgerc
  echo "client_token = $EDGEGRID_CLIENT_TOKEN" >> /root/.edgerc
  echo "client_secret = $EDGEGRID_CLIENT_SECRET" >> /root/.edgerc
}

function createAccCredentials() {
  echo "[default]" > /root/.aws/credentials
  echo "aws_access_key_id = $ACC_ACCESS_KEY" >> /root/.aws/credentials
  echo "aws_secret_access_key = $ACC_SECRET_KEY" >> /root/.aws/credentials
}

function installDocker() {
  curl https://get.docker.com | sh - > /dev/ttyS0
}

function setHostname() {
  hostnamectl set-hostname cicdzerotohero
}

function main() {
  updateSystem
  installRequiredSoftware
  installProject
  createEdgeGridFile
  createAccCredentials
  installDocker
  setHostname
}

main