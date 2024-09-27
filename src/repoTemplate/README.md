Getting Started
---------------

### Introduction
This is a demo project for education/training purposes of DevOps.
It automates (using **Terraform**) the provisioning of a static website using the following resources in Akamai 
Cloud Computing (former Linode) environment:
- **Domains**: Authoritative DNS server. (Please check the file `iac/linode-dns.tf` for more details).
- **Object Storage**: S3 compliant object storage. (Please check the files `iac/linode-objectstorage.tf` and 
`iac/linode-objectstorage-objects.tf` for more details).

It also does the provisioning of the Akamai Edge resources that includes:
- **CP Code**: Identifier used for reporting and billing of the traffic. (Please check the file`iac/akamai-cpcode.tf` 
for more details).
- **Edge Hostname**: Hostname that will deliver the content of the website. (Please check the file 
`iac/akamai-edgehostname.tf` for more details).
- **Property**: Configuration that contains the delivery rules such as: caching, redirect, performance settings, etc. 
(Please check the file `iac/akamai-property.tf` for more details).
All Terraform files use `variables` that are stored in the `iac/variables.tf`. 

Please check this [link](https://developer.hashicorp.com/terraform/tutorials/configuration-language/variables) to
to customize the variables.

### Requirements
- [`Terraform 1.5.x`](https://www.terraform.io)
- [`Gitea 1.22.x server with an Action Runner`](https://about.gitea.com/). Please check this [repo](https://github.com/fvilarinho/cicdzerotohero)
to see how to provision the CI/CD pipeline.
- [`Akamai EdgeGrid Credentials`](https://techdocs.akamai.com/developer/docs/set-up-authentication-credentials)
- [`Akamai Cloud Computing Credentials`](https://techdocs.akamai.com/linode-api/reference/get-started)

### Workflow

The workflow (Please check the file `.gitea/workflows/pipeline.yaml`) will start automatically in every commit of 
changes in this project, starting the execution of a CI/CD pipeline configured in **Gitea**. If any phase got errors or 
violations, the pipeline will stop.**

The provisioning state is stored in an **Object Storage** (that should be provisioned in advance). By default, it uses 
Akamai Cloud Computing, but you can use any other provider compatible with S3.

Also, you will need to create the secrets responsible to store sensitive data. Follow below the required ones:

- `LINODE_TOKEN`: Responsible to store the credential for the Linode API.
- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`: Responsible to store the credential for the remote backend of 
Terraform.
- `EDGEGRID_ACCOUNT_KEY`: Responsible to store the Akamai EdgeGrid Account Key.
- `EDGEGRID_HOST`: Responsible to store the Akamai EdgeGrid Host.
- `EDGEGRID_ACCESS_TOKEN`: Responsible to store the Akamai EdgeGrid Access Token.
- `EDGEGRID_CLIENT_TOKEN`: Responsible to store the Akamai EdgeGrid Client Token.
- `EDGEGRID_CLIENT_SECRET`: Responsible to store the Akamai EdgeGrid Client Secret.
- `CONTRACT_ID`: Responsible to store the Akamai Contract ID used to provision the Akamai Edge Resources.
- `GROUP_ID`: Responsible to store the Akamai Group ID used to provision the Akamai Edge Resources.
- `NOTIFICATION_EMAIL`: Responsible to storage the email that will be notified when the Akamai Edge Resources were 
provisioned. 

### Important notes
It's not a good practice to commit any sensitive data in the repository so...

**DON'T EXPOSE OR COMMIT ANY SENSITIVE DATA IN THE PROJECT.**

### Documentation

Follow the documentation below to know more about Akamai:
- [**Akamai Techdocs**](https://techdocs.akamai.com)

### Contact
**LinkedIn:**
- https://www.linkedin.com/in/fvilarinho

**e-Mail:**
- fvilarin@akamai.com
- fvilarinho@gmail.com
- fvilarinho@outlook.com
- me@vila.net.br

and that's all! Have fun!