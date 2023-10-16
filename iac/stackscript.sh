#!/bin/bash
# <UDF name="EDGEGRID_HOST" Label="TLS Certificate" example="Copy & Paste the TLS certificate used for HTTPs connection."/>
# <UDF name="EDGEGRID_ACCESS_TOKEN" Label="TLS Certificate" example="Copy & Paste the TLS certificate used for HTTPs connection."/>
# <UDF name="EDGEGRID_CLIENT_TOKEN" Label="TLS Certificate" example="Copy & Paste the TLS certificate used for HTTPs connection."/>
# <UDF name="EDGEGRID_CLIENT_SECRET" Label="TLS Certificate" example="Copy & Paste the TLS certificate used for HTTPs connection."/>
# <UDF name="ACC_TOKEN" Label="TLS Certificate Key" example="Copy & Paste the TLS certificate key used for HTTPs connection."/>
# <UDF name="ACC_OBJECT_STORAGE_ACCESS_KEY" Label="TLS Certificate Key" example="Copy & Paste the TLS certificate key used for HTTPs connection."/>
# <UDF name="ACC_OBJECT_STORAGE_SECRET_KEY" Label="TLS Certificate Key" example="Copy & Paste the TLS certificate key used for HTTPs connection."/>

apt -y update > /dev/ttyS0
apt -y upgrade > /dev/ttyS0
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



echo "$TLS_CERTIFICATE" > ./ingress/settings/cert.crt
echo "$TLS_CERTIFICATE_KEY" > ./ingress/settings/cert.key

echo "$EDGE_RC" > /root/.edgerc

echo "$ACC_CREDENTIALS" > /root/.credentials

curl https://get.docker.com | sh - > /dev/ttyS0