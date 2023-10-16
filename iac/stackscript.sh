#!/bin/bash

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
git clone https://github.com/fvilarinho/cicdzerotohero > /dev/ttyS0
cd cicdzerotohero || exit 1
mv iac/docker-compose.yml .
rm -rf .git
rm -rf iac
rm -f *sh
rm -f *.txt
rm -f LICENSE
rm -f *.md
rm .gitignore
curl https://get.docker.com | sh - > /dev/ttyS0
