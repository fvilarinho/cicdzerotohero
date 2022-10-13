## CI/CD Zero to Hero

### Introduction
This project has the intention to demonstrate the basics of a CI/CD pipeline by provisioning a GIT and a Jenkins instance in Linode using Terraform.

### Requirements
- [`Terraform 1.3.x`](https://terraform.io)
- [`Linode Account`](https://www.linode.com)
- [`Any Linux Distribution`] or
- [`Windows 10 or later`] or
- [`MacOS Catalina or later`]

### Setup
You need to create an API Token in Linode. Follow this path: Click in your `Profile Icon -> API Tokens -> Create a Personal Access Token`. You need to select `Read-Write` permission for the following:
- Linodes
- StackScripts
- Account

Then click in the `Create Token` button. A dialog with the token will popup. Please note the token value because uou won't be able to get the token after you clock the popup.

Then define an environment variable called `LINODE_TOKEN` in your local machine with the token value.

After that, just execute the command `./deploy.sh` in your project directory. Follow the instructions for the setup. After the setup is done, please add the following Jenkins plugins:

- [`Gogs`](https://plugins.jenkins.io/gogs-webhook/)
- [`Blueocean`](https://plugins.jenkins.io/blueocean/)

and that's all!
