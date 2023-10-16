#!/bin/bash
# <UDF name="EDGEGRID_HOST" Label="Akamai EdgeGrid Hostname" example="Hostname used to authenticate in Akamai Intelligent Platform using APIs/CLI or Terraform calls."/>
# <UDF name="EDGEGRID_ACCESS_TOKEN" Label="Akamai EdgeGrid Access Token" example="Access Token used to authenticate in Akamai Intelligent Platform using APIs/CLI or Terraform calls."/>
# <UDF name="EDGEGRID_CLIENT_TOKEN" Label="Akamai EdgeGrid Client Token" example="Client Token used to authenticate in Akamai Intelligent Platform using APIs/CLI or Terraform calls."/>
# <UDF name="EDGEGRID_CLIENT_SECRET" Label="Akamai EdgeGrid Client Secret" example="Client Secret used to authenticate in Akamai Intelligent Platform using APIs/CLI or Terraform calls."/>
# <UDF name="ACC_TOKEN" Label="Akamai Connected Cloud Access Key" example="Token used to authenticate in the Akamai Connected Cloud using APIs/CLI or Terraform calls."/>
# <UDF name="REMOTEBACKEND_ID" Label="Terraform Remote Backend Identifier" example="Identifier of Terraform Remote Backend used to control the provisioning states of the resources."/>
# <UDF name="REMOTEBACKEND_REGION" Label="Terraform Remote Backend Region" example="Region of Terraform Remote Backend used to control the provisioning states of the resources."/>

function setHostname() {
  echo "Setting the hostname..." > /dev/ttyS0

  hostnamectl set-hostname cicdzerotohero
}

function updateSystem() {
  setHostname

  echo "Updating the system..." > /dev/ttyS0

  apt update
  apt -y upgrade
}

function installRequiredSoftware() {
  echo "Installing basic software..." > /dev/ttyS0

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
                 htop

  installTerraform
  installAkamaiCLI
  installPowershell
  installDocker
  installCiCd
}

function installTerraform() {
  echo "Installing Terraform..." > /dev/ttyS0

  wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
  apt update
  apt -y install terraform
}

function installAkamaiCLI() {
  echo "Installing Akamai CLI..." > /dev/ttyS0

  wget https://github.com/akamai/cli/releases/download/v1.5.5/akamai-v1.5.5-linuxamd64 -o /usr/bin/akamai
  chmod +x /usr/bin/akamai
}

function installPowershell() {
  echo "Installing Akamai PowerShell..." > /dev/ttyS0

  wget https://github.com/PowerShell/PowerShell/releases/download/v7.3.8/powershell-7.3.8-linux-x64.tar.gz -o /tmp/powershell-7.3.8-linux-x64.tar.gz
  mkdir /root/powershell
  mv /tmp/powershell-7.3.8-linux-x64.tar.gz /root/powershell
  cd /root/powershell || exit 1
  tar xvzf powershell-7.3.8-linux-x64.tar.gz
}

function installDocker() {
  echo "Installing Docker..." > /dev/ttyS0

  curl https://get.docker.com | sh -
}

function installCiCd() {
  echo "Installing CI/CD..." > /dev/ttyS0

  mkdir /root/.aws

  git clone https://github.com/fvilarinho/cicdzerotohero /root/cicdzerotohero

  cd /root/cicdzerotohero || exit 1

  rm -rf .git
  rm -f .gitignore

  createEdgeGridFile
  createRemoteBackend
}

function createEdgeGridFile() {
  echo "Creating Akamai EdgeGrid file..." > /dev/ttyS0

  echo "[default]" > /root/.edgerc
  echo "host = $EDGEGRID_HOST" >> /root/.edgerc
  echo "access_token = $EDGEGRID_ACCESS_TOKEN" >> /root/.edgerc
  echo "client_token = $EDGEGRID_CLIENT_TOKEN" >> /root/.edgerc
  echo "client_secret = $EDGEGRID_CLIENT_SECRET" >> /root/.edgerc
}

function createRemoteBackend() {
  echo "Creating Terraform Remote Backend..." > /dev/ttyS0

  cd /root/cicdzerotohero/iac || exit 1

  terraform init \
            -upgrade \
            -migrate-state

  exists=$(terraform state list | grep "module.remotebackend.linode_object_storage_bucket.remotebackend")

  if [ -z "$exists" ]; then
    terraform import "module.remotebackend.linode_object_storage_bucket.remotebackend" "$REMOTEBACKEND_REGION:$REMOTEBACKEND_ID"
  fi

  terraform plan \
            -target=module.remotebackend \
            -compact-warnings \
            -var "accToken=$ACC_TOKEN" \
            -var "remoteBackendId=$REMOTEBACKEND_ID" \
            -var "remoteBackendRegion=$REMOTEBACKEND_REGION"

  terraform apply \
            -auto-approve \
            -target=module.remotebackend \
            -compact-warnings \
            -var "accToken=$ACC_TOKEN" \
            -var "remoteBackendId=$REMOTEBACKEND_ID" \
            -var "remoteBackendRegion=$REMOTEBACKEND_REGION"
}

function startCiCd() {
  cd /root/cicdzerotohero || exit 1

  ./start.sh
}

function main() {
  clear

  echo "Initializing the setup..."

  updateSystem
  installRequiredSoftware
  startCiCd
}

main