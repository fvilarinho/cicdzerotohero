## CI/CD Zero to Hero

### Introduction
This project has the intention to demonstrate the basics of a CI/CD pipeline by provisioning a compute instance with 
Git server (Gitea with Actions Runner) with pre-installed tools:

- [`Terraform`](https://terraform.io)
- [`Docker`](https://www.docker.com)
- [`NodeJS`](https://nodejs.org)
- [`NPM`](https://www.npmjs.com)
- [`Gitea`](https://gitea.com)
- [`Gitea Action Runner`](https://docs.gitea.com/usage/actions/act-runner)

### Requirements for you local machine
- [`Docker`](https://www.docker.com)
- `Any Linux Distribution` or
- `Windows 10 or later` or
- `MacOS Catalina or later`

### To customize the Gitea Server and Action Runner

You can customize adding new software and/or patching. To do it, just edit the following files:

- `gitea-server/Dockerfile` 
- `gitea-runner/Dockerfile`

After that, execute the following commands:

- `build.sh`: To build the container images.
- `publish.sh`: To publish the container images in the container registry.

### Important notes
- **DON'T EXPOSE OR COMMIT ANY SENSITIVE DATA, SUCH AS CREDENTIALS, IN THE PROJECT.**

### Contact
**LinkedIn:**
- https://www.linkedin.com/in/fvilarinho

**e-Mail:**
- fvilarinho@gmail.com
- fvilarinho@outlook.com
- me@vila.net.br

and that's all! Have fun!