#!/bin/bash
# <UDF name="EDGEGRID_HOST" Label="Akamai EdgeGrid Hostname" example="Hostname used to authenticate in Akamai Intelligent Platform using APIs/CLI or Terraform calls."/>
# <UDF name="EDGEGRID_ACCESS_TOKEN" Label="Akamai EdgeGrid Access Token" example="Access Token used to authenticate in Akamai Intelligent Platform using APIs/CLI or Terraform calls."/>
# <UDF name="EDGEGRID_CLIENT_TOKEN" Label="Akamai EdgeGrid Client Token" example="Client Token used to authenticate in Akamai Intelligent Platform using APIs/CLI or Terraform calls."/>
# <UDF name="EDGEGRID_CLIENT_SECRET" Label="Akamai EdgeGrid Client Secret" example="Client Secret used to authenticate in Akamai Intelligent Platform using APIs/CLI or Terraform calls."/>
# <UDF name="ACC_TOKEN" Label="Akamai Connected Cloud Access Key" example="Token used to authenticate in the Akamai Connected Cloud using APIs/CLI or Terraform calls."/>
# <UDF name="REMOTEBACKEND_ID" Label="Terraform Remote Backend Identifier" example="Identifier of Terraform Remote Backend used to control the provisioning states of the resources."/>
# <UDF name="REMOTEBACKEND_REGION" Label="Terraform Remote Backend Region" example="Region of Terraform Remote Backend used to control the provisioning states of the resources."/>

function setHostname() {
  hostnamectl set-hostname cicdzerotohero
}

function updateSystem() {
  setHostname

  apt update > /dev/ttyS0
  apt -y upgrade > /dev/ttyS0
}

function installRequiredSoftware() {
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

  installTerraform
  installAkamaiCLI
  installPowershell
  installDocker
  installCiCd
}

function installTerraform() {
  wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
  apt update
  apt -y install terraform > /dev/ttyS0
}

function installAkamaiCLI() {
  wget https://github.com/akamai/cli/releases/download/v1.5.5/akamai-v1.5.5-linuxamd64 -o /usr/bin/akamai
  chmod +x /usr/bin/akamai
}

function installPowershell() {
  wget https://github.com/PowerShell/PowerShell/releases/download/v7.3.8/powershell-7.3.8-linux-x64.tar.gz -o /tmp/powershell-7.3.8-linux-x64.tar.gz
  mkdir /root/powershell
  mv /tmp/powershell-7.3.8-linux-x64.tar.gz /root/powershell
  cd /root/powershell || exit 1
  tar xvzf powershell-7.3.8-linux-x64.tar.gz > /dev/ttyS0
}

function installDocker() {
  curl https://get.docker.com | sh - > /dev/ttyS0
}

function installCiCd() {
  mkdir /root/.aws

  git clone https://github.com/fvilarinho/cicdzerotohero /root/cicdzerotohero > /dev/ttyS0

  cd /root/cicdzerotohero || exit 1

  rm -rf .git
  rm -f .gitignore

  createEdgeGridFile
  createRemoteBackend
}

function createEdgeGridFile() {
  echo "[default]" > /root/.edgerc
  echo "host = $EDGEGRID_HOST" >> /root/.edgerc
  echo "access_token = $EDGEGRID_ACCESS_TOKEN" >> /root/.edgerc
  echo "client_token = $EDGEGRID_CLIENT_TOKEN" >> /root/.edgerc
  echo "client_secret = $EDGEGRID_CLIENT_SECRET" >> /root/.edgerc
}

function createRemoteBackend() {
  cd /root/cicdzerotohero/iac || exit 1

  terraform init \
            -upgrade \
            -migrate-state > /dev/ttyS0

  exists=$(terraform state list | grep "module.remotebackend.linode_object_storage_bucket.remotebackend")

  if [ -z "$exists" ]; then
    terraform import "module.remotebackend.linode_object_storage_bucket.remotebackend" "$REMOTEBACKEND_REGION:$REMOTEBACKEND_ID" > /dev/ttyS0
  fi

  terraform plan \
            -target=module.remotebackend \
            -compact-warnings \
            -var "accToken=$ACC_TOKEN" \
            -var "remoteBackendId=$REMOTEBACKEND_ID" \
            -var "remoteBackendRegion=$REMOTEBACKEND_REGION" > /dev/ttyS0

  terraform apply \
            -auto-approve \
            -target=module.remotebackend \
            -compact-warnings \
            -var "accToken=$ACC_TOKEN" \
            -var "remoteBackendId=$REMOTEBACKEND_ID" \
            -var "remoteBackendRegion=$REMOTEBACKEND_REGION" > /dev/ttyS0
}

function startCiCd() {
  cd /root/cicdzerotohero || exit 1

  ./start.sh
}

function main() {
  updateSystem
  installRequiredSoftware
  startCiCd
}

main