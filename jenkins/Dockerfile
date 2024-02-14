# Base image.
FROM jenkins/jenkins:lts

ENV GITEA_HOST=gitea

# Change to root to have the permission to install additional software.
USER root

# Updates the system and install basic software.
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt update && \
    apt -y upgrade && \
    apt -y install ca-certificates \
                   gnupg2 \
                   software-properties-common \
                   libicu-dev \
                   jq \
                   curl \
                   wget \
                   vim \
                   npm \
                   unzip \
                   python3 \
                   python3-pip

# Installs Terraform.
RUN wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip -O /tmp/terraform.zip && \
    cd /tmp && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin && \
    chmod +x /usr/local/bin/terraform

# Installs Akamai CLI.
RUN wget https://github.com/akamai/cli/releases/download/v1.5.5/akamai-v1.5.5-linuxamd64 -O /usr/bin/akamai && \
    chmod +x /usr/bin/akamai

# Installs Akamai Powershell.
RUN wget https://github.com/PowerShell/PowerShell/releases/download/v7.3.8/powershell-7.3.8-linux-x64.tar.gz -O /tmp/powershell-7.3.8-linux-x64.tar.gz && \
    mkdir -p /opt/powershell && \
    mv /tmp/powershell-7.3.8-linux-x64.tar.gz /opt/powershell && \
    cd /opt/powershell && \
    tar xvzf powershell-7.3.8-linux-x64.tar.gz && \
    rm powershell-7.3.8-linux-x64.tar.gz && \
    ln -sf /opt/powershell/pwsh /usr/bin/pwsh

# Copy the required files.
COPY bin/*.sh /usr/local/bin

# Creates the required directories.
RUN mkdir -p /var/jenkins_home/.ssh && \
    chown -R jenkins:jenkins /var/jenkins_home/.ssh && \
    chmod +x /usr/local/bin/*.sh && \
    ln -s /usr/local/bin/startup.sh /entrypoint.sh

# Changes to the basic user.
USER jenkins

# Defines the new entrypoint to boot.
ENTRYPOINT [ "/entrypoint.sh" ]