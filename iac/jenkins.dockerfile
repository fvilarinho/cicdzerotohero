# Base image.
FROM jenkins/jenkins:lts

# Change to root to have the permission to install software.
USER root

# Update the system and install basic software.
RUN apt update && \
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

# Install Terraform.
RUN wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip -O /tmp/terraform.zip && \
    cd /tmp && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin && \
    chmod +x /usr/local/bin/terraform

# Install Akamai CLI.
RUN wget https://github.com/akamai/cli/releases/download/v1.5.5/akamai-v1.5.5-linuxamd64 -O /usr/bin/akamai && \
    chmod +x /usr/bin/akamai

# Install Akamai Powershell.
RUN wget https://github.com/PowerShell/PowerShell/releases/download/v7.3.8/powershell-7.3.8-linux-x64.tar.gz -O /tmp/powershell-7.3.8-linux-x64.tar.gz && \
    mkdir -p /opt/powershell && \
    mv /tmp/powershell-7.3.8-linux-x64.tar.gz /opt/powershell && \
    cd /opt/powershell && \
    tar xvzf powershell-7.3.8-linux-x64.tar.gz && \
    rm powershell-7.3.8-linux-x64.tar.gz && \
    ln -sf /opt/powershell/pwsh /usr/bin/pwsh

# Create required directories.
RUN mkdir -p /var/jenkins_home/.ssh

# Change boot script to validate the SSH connection with the Gitea.
RUN chown -R jenkins:jenkins /var/jenkins_home/.ssh && \
    echo "#!/bin/bash" > /usr/local/bin/setup.sh && \
    echo >> /usr/local/bin/setup.sh && \
    echo "rm -f /var/jenkins_home/.ssh/known_hosts*" >> /usr/local/bin/setup.sh && \
    echo "ssh-keyscan gitea > /var/jenkins_home/.ssh/known_hosts" >> /usr/local/bin/setup.sh && \
    chmod +x /usr/local/bin/setup.sh && \
    echo "#!/bin/bash" > /entrypoint.sh && \
    echo >> /entrypoint.sh && \
    echo "/usr/local/bin/setup.sh" >> /entrypoint.sh && \
    echo "/usr/local/bin/jenkins.sh" >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Change to the basic user.
USER jenkins

# Define the new entrypoint to boot.
ENTRYPOINT [ "/entrypoint.sh" ]