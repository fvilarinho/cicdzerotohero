## CI/CD Zero to Hero

### Introduction
This project has the intention to demonstrate the basics of a CI/CD pipeline by provisioning a git server and action 
runner with the following pre-installed tools:

- [JQ](https://jqlang.org/)
- [NodeJS](https://nodejs.org)
- [NPM](https://www.npmjs.com/)
- [Python](https://www.python.org/)
- [OpenJDK](https://openjdk.org/)
- [Gradle](https://gradle.org/)
- [Maven](https://maven.apache.org/)
- [Snyk](https://snyk.io/platform/snyk-cli/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
- [Docker](https://www.docker.com/)
- [Terraform](https://terraform.io/)

You can also customize by adding new software and/or patching. Just edit the following files:

- `gitea-server/Dockerfile`
- `gitea-runner/Dockerfile`

### Requirements to run, build or publish
- [Docker](https://www.docker.com)
- `Any Linux Distribution` or
- `Windows 10 or later` or
- `MacOS Catalina or later`

Execute the following to:

- `build.sh`: Build the stack.
- `publish.sh`: Publish the stack in the container registry.
- `start.sh`: Starts the stack.
- `stop.sh`: Stops the stack.

### Environment variables:
Create the file `.secrets` to contains the following credentials, secrets and keys for the stack:
- `DOCKER_REGISTRY_PASSWORD`: Password of the container registry.
- `GITEA_SERVER_URL`: URL of the Gitea server used to registry the action runners.
- `GITEA_SERVER_TOKEN`: Token of the Gitea server used to registry the action runners.

In the file `.env`, you can customize the following:
- `DOCKER_REGISTRY_URL`: URl of the container registry.
- `DOCKER_REGISTRY_ID`: Identity of the container registry.
- `BUILD_VERSION`: Version of the stack.
- `GITEA_RUNNER_NAME`: Name of the action runner.
- `GITEA_RUNNER_LABELS`: Labels of the action runner.

### Important notes
- **DON'T EXPOSE OR COMMIT ANY SENSITIVE DATA (SUCH AS CREDENTIALS, SECRETS, KEYS, etc.) IN THE PROJECT.**

### Contact
**Website**
- [https://vilanet.sh](https://vilanet.sh)

**e-Mail:**
- me@vila.net.br
- fvilarinho@gmail.com
- fvilarinho@outlook.com

and that's all! Have fun!