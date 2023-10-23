## CI/CD Zero to Hero

### Introduction
This project has the intention to demonstrate the basics of a CI/CD pipeline by provisioning Git server (Gitea) and 
Jenkins (with Terraform, Akamai CLI and Akamai Powershell) in Akamai Connected Cloud.
It provisions a Compute instance and also the StackScript that contains the recipe to set up everything. 

### Requirements
- [`Terraform 1.5.x`](https://terraform.io)
- [`Akamai Connected Cloud Account`](https://www.linode.com)
- [`Any Linux Distribution`] or
- [`Windows 10 or later`] or
- [`MacOS Catalina or later`]

### Setup
You need to create an API Token in Akamai Connected Cloud. Follow this path: Click in your `Profile Icon -> API Tokens -> Create a Personal Access Token`. You need to select `Read-Write` permission for the following:
- Linodes
- StackScripts
- Object Storage

Then click in the `Create Token` button. A dialog with the token will popup. Please note the token value because you 
won't be able to get the token after you clock the popup.

Then define an environment variable called `ACC_TOKEN` in your local machine with the token value.
You will need also to define following environment variables for Akamai EdgeGrid:
- `EDGEGRID_ACCOUNT_KEY`
- `EDGEGRID_HOST`
- `EDGEGRID_ACCESS_TOKEN`
- `EDGEGRID_CLIENT_TOKEN`
- `EDGEGRID_CLIENT_SECRET`

Please follow the instructions in [`Akamai Techdocs`](https://techdocs.akamai.com) to know how to create the Akamai 
EdgeGrid credentials.

After that, just execute the command `./deploy.sh` in your project directory. Follow the instructions in the console of
your instance.

To undeploy, just execute the command `./undeploy.sh` in your project directory.

If you want to customize the specifications of your provisioning/setup, please edit `iac/modules/provisioning` and/or
`iac/modules/setup`.

If you

and that's all!
