## CI/CD Zero to Hero

### Introduction
This project has the intention to demonstrate the basics of a CI/CD pipeline by provisioning a compute instance with 
Git server (Gitea) and Jenkins in Akamai Connected Cloud with pre-installed tools:

- [`Terraform 1.5.7`](https://terraform.io)
- [`Akamai CLI 1.5.5`](https://github.com/akamai/cli)
- [`Akamai Poweshell 7.3.8`](https://github.com/akamai/akamaipowershell)
- [`Docker 24.x`](https://www.docker.com)
- [`NodeJS 20.x`](https://nodejs.org)
- [`NPM 10.x`](https://www.npmjs.com)
- [`Python 3.x`](https://www.python.org/)
- [`Gitea 1.9`](https://gitea.com)
- [`JQ 1.7`](https://jqlang.github.io/jq/)
- [`Jenkins LTS`](https://jenkins.io)

It also provisions the StackScript that contains the recipe to set up everything using the Akamai Connected Cloud UI.

### Requirements in you local machine
- [`Terraform 1.5.7`](https://terraform.io)
- [`Docker 24.x`](https://www.docker.com)
- [`NodeJS 20.x`](https://nodejs.org)
- [`NPM 10.x`](https://www.npmjs.com)
- `Any Linux Distribution` or
- `Windows 10 or later` or
- `MacOS Catalina or later`

Define the environment variables below in your local machine:
- `EDGEGRID_ACCOUNT_KEY`: Akamai Account Key to be used in APIs/CLI or Terraform calls.
- `EDGEGRID_HOST`: Hostname used to authenticate the APIs/CLI/Terraform calls, using the Akamai EdgeGrid.
- `EDGEGRID_ACCESS_TOKEN`: Access Token used to authenticate the APIs/CLI/Terraform calls, using the Akamai EdgeGrid.
- `EDGEGRID_CLIENT_TOKEN`: Client Token used to authenticate the APIs/CLI/Terraform calls, using the Akamai EdgeGrid.
- `EDGEGRID_CLIENT_SECRET`: Client Secret used to authenticate the APIs/CLI/Terraform calls, using the Akamai EdgeGrid.
- `ACC_TOKEN`: Token used to authenticate the APIs/CLI/Terraform calls in the Akamai Connected Cloud.

or define the credentials in the `iac/.credentials` filename. Please follow the template `iac/.credentials.template`.

### To run it in you local machine

Just execute the commands below:

- `start.sh`: Starts the stack.
- `stop.sh`: Stops the stack.
- `reload.sh`: Reloads the stack.

### To run it in Akamai Connected Cloud

You'll need to create an API Token in Akamai Connected Cloud. Please follow this path: Click in your
`Profile Icon -> API Tokens -> Create a Personal Access Token`. You need to select `Read-Write` permission for the 
following:

- Linodes (Compute instances)
- StackScripts (Recipes to automate provisioning/install/setup)
- Object Storage (Used to store static files and the provisioning states).

Then click in the `Create Token` button. A dialog with the token will popup. Please note the token value before you 
close the popup. You won't be able to get the token after.

After that, just execute the command `deploy.sh` in your project directory. Follow the instructions in the console of
your instance. If you want to customize the specifications of your provisioning/setup, please edit 
`iac/modules/provisioning` and/or`iac/modules/setup`.

To undeploy, just execute the command `undeploy.sh` in your project directory.

### To build Gitea and Jenkins

To customize the container images, just edit the following files:

- `iac/.env`: It contains the container registry information and the build version.
- `iac/docker-compose.yml`: It contains the definition of the container images (platform, ports, volumes, environments, 
etc.).
- `iac/gitea.dockerfile`: It contains the definition to build Gitea.
- `iac/jenkins.dockerfile`: It contains the definition to build Jenkins.

After that, execute the following commands:

- `build.sh`: To build the container images.
- `publish.sh`: To publish the container images in the container registry.

### Documentation

Follow the documentation below to know more about Akamai:

- [**How to create Akamai EdgeGrid credentials**](https://techdocs.akamai.com/developer/docs/make-your-first-api-call)
- [**How to create Akamai Connected Cloud credentials**](https://www.linode.com/docs/api)
- [**Akamai Techdocs**](https://techdocs.akamai.com)
- [**Akamai Connected Cloud Documentation**](https://www.linode.com/docs/)

### Important notes
- **If any phase got errors or violations, the pipeline will stop.**
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