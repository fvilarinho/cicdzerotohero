FROM gitea/act_runner:latest

# Updates the stock image and install NodeJS.
RUN apk update && \
    apk add --no-cache nodejs npm

# Installs Terraform.
RUN wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip -O /tmp/terraform.zip && \
    cd /tmp && \
    unzip terraform.zip && \
    rm terraform.zip && \
    mv terraform /usr/local/bin && \
    chmod og+x /usr/local/bin/terraform