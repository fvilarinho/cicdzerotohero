#!/bin/bash

apt -y update
apt -y upgrade
apt -y install ca-certificates \
               curl \
               wget \
               dnsutils \
               net-tools \
               vim \
               gnupg2 \
               sqlite3 \
               git \
               htop
curl https://get.docker.com | sh -
curl -o main.zip https://github.com/fvilarinho/cicdzerotohero/archive/refs/heads/main.zip
unzip main.zip
mv iac/docker-compose.yml .
rm -rf iac
rm -f *sh
rm -f *.txt
rm -f LICENSE
rm -f *.md
rm .gitignore
rm main.zip