FROM jenkins/jenkins:lts

USER root

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
                   python3 \
                   python3-pip

RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt update && \
    apt -y install terraform

RUN wget https://github.com/akamai/cli/releases/download/v1.5.5/akamai-v1.5.5-linuxamd64 -O /usr/bin/akamai && \
    chmod +x /usr/bin/akamai

RUN wget https://github.com/PowerShell/PowerShell/releases/download/v7.3.8/powershell-7.3.8-linux-x64.tar.gz -O /tmp/powershell-7.3.8-linux-x64.tar.gz && \
    mkdir -p /opt/powershell && \
    mv /tmp/powershell-7.3.8-linux-x64.tar.gz /opt/powershell && \
    cd /opt/powershell && \
    tar xvzf powershell-7.3.8-linux-x64.tar.gz && \
    rm powershell-7.3.8-linux-x64.tar.gz && \
    ln -sf /opt/powershell/pwsh /usr/bin/pwsh

RUN echo "mkdir -p /var/jenkins_home/.ssh; ssh-keyscan gitea > /var/jenkins_home/.ssh/known_hosts" > /usr/local/bin/knowGitea.sh && \
    chmod +x /usr/local/bin/knowGitea.sh && \
    echo "#!/bin/bash" > /entrypoint.sh && \
    echo >> /entrypoint.sh && \
    echo "/usr/local/bin/knowGitea.sh" >> /entrypoint.sh && \
    echo "/usr/local/bin/jenkins.sh" >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

USER jenkins

ENTRYPOINT [ "/entrypoint.sh" ]