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
  echo "Installing required software..." > /dev/ttyS0

  apt -y install ca-certificates \
                 gnupg2 \
                 curl \
                 wget \
                 vim \
                 git

  installTerraform
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

function installDocker() {
  echo "Installing Docker..." > /dev/ttyS0

  curl https://get.docker.com | sh -

  systemctl enable docker
}

function installCiCd() {
  echo "Installing CI/CD..." > /dev/ttyS0

  mkdir /root/.aws

  git clone https://github.com/fvilarinho/cicdzerotohero /root/cicdzerotohero

  cd /root/cicdzerotohero || exit 1

  rm -rf .git
  rm -f .gitignore

  createRemoteBackend
  createEdgeGridFile
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
  echo "Starting CI/CD..." > /dev/ttyS0

  cd /root/cicdzerotohero || exit 1

  ./start.sh
}

function main() {
  updateSystem
  installRequiredSoftware
  startCiCd

  echo "Continue the setup in the UI!" > /dev/ttyS0
  echo > /dev/ttyS0
  echo "For GITEA, access https://$(curl ipinfo.io/ip):8443" > /dev/ttyS0
  echo "For Jenkins, access https://$(curl ipinfo.io/ip):8444" > /dev/ttyS0
  echo > /dev/ttyS0
  echo "Jenkins initial password is: " > /dev/ttyS0

  docker exec -it "$(docker ps|grep jenkins|awk '{print $1}')" cat /var/jenkins_home/secrets/initialAdminPassword
}

main