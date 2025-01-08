FROM gitea/act_runner:0.2.11

# Updates the stock image and install NodeJS.
RUN apk update && \
    apk add --no-cache nodejs \
                       npm \
                       curl \
                       jq \
                       apache2-utils \
                       openjdk17-jre \
                       docker \
                       docker-cli-compose

RUN npm install snyk -g
RUN curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

# Installs Terraform.
RUN wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip -O /tmp/terraform.zip && \
    cd /tmp && \
    unzip terraform.zip && \
    rm terraform.zip && \
    mv terraform /usr/local/bin && \
    chmod og+x /usr/local/bin/terraform