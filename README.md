## CI/CD Zero to Hero

### Introduction
This project has the intention to demonstrate the basics of a CI/CD pipeline by provisioning a compute instance with 
Git server (Gitea with Actions Runner) in Akamai Cloud Computing with pre-installed tools:

- [`Terraform 1.5.x`](https://terraform.io)
- [`Docker 24.x`](https://www.docker.com)
- [`NodeJS 20.x`](https://nodejs.org)
- [`NPM 10.x`](https://www.npmjs.com)
- [`Gitea 1.22.x`](https://gitea.com)
- [`Gitea Action Runner 0.2.x`](https://docs.gitea.com/usage/actions/act-runner)

It automates (using **Terraform**) the provisioning of the following resources in Akamai Cloud Computing (former Linode) 
environment:
- **Domains**: Authoritative DNS server. (Please check the file `iac/linode-dns.tf` for more details).
- **Firewall**: Cloud Firewall. (Please check the file `iac/linode-firewall.tf` for more details).
- **Linodes**: Compute instances to run Gitea and Action Runner. (Please check the file `iac/linode-compute.tf` for more 
- **Credentials**: SSH Private/Public Keys used to access the compute instances (Please check the file `iac/linode-credentials.tf`
for more details).
- **TLS Certificate**: LetsEncrypt signed certificate to enable HTTPs traffic in the compute instances. (Please check 
the file `iac/certificate.tf` for more details).

### Requirements for you local machine
- [`Terraform 1.5.x`](https://terraform.io)
- [`Docker 24.x`](https://www.docker.com)
- `Any Linux Distribution` or
- `Windows 10 or later` or
- `MacOS Catalina or later`

All Terraform files use `variables` that are stored in the `iac/variables.tf`.

Please check this [link](https://developer.hashicorp.com/terraform/tutorials/configuration-language/variables) to know how to customize the variables.

### To deploy it in Akamai Cloud Computing

Just execute the command `deploy.sh` in your project directory. To undeploy, just execute the command `undeploy.sh` in 
your project directory.

### To customize the Gitea Action Runner

You can customize the Action Runner adding new software and/or patching. To do it, just edit the following files:

- `iac/.env`: It contains the container registry information and the build version.
- `iac/Dockerfile`: It contains the definition of the container image (required software, etc.). 

After that, execute the following commands:

- `build.sh`: To build the container images.
- `publish.sh`: To publish the container images in the container registry.

### Documentation

Follow the documentation below to know more about Akamai:
- [**Akamai Techdocs**](https://techdocs.akamai.com)

### Important notes
- **DON'T EXPOSE OR COMMIT ANY SENSITIVE DATA, SUCH AS CREDENTIALS, IN THE PROJECT.**

### Contact
**LinkedIn:**
- https://www.linkedin.com/in/fvilarinho

**e-Mail:**
- fvilarin@akamai.com
- fvilarinho@gmail.com
- fvilarinho@outlook.com
- me@vila.net.br

and that's all! Have fun!