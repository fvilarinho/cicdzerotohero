FROM gitea/act_runner:latest

USER root

RUN wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip -O /tmp/terraform.zip && \
    cd /tmp && \
    unzip terraform.zip