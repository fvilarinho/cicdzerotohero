# Required variables.
locals {
  serverConfigurationFilename = abspath(pathexpand("../etc/gitea-server/nginx/conf.d/default.conf"))
  serverDeploymentFilename    = abspath(pathexpand("../etc/gitea-server/docker-compose.yml"))
  startServerScript           = abspath(pathexpand("../bin/gitea-server/start.sh"))

  runnerEnvironmentFilename = abspath(pathexpand("../etc/gitea-runner/.env"))
  runnerImageFilename       = abspath(pathexpand("../etc/gitea-runner/Dockerfile"))
  startRunnerScript         = abspath(pathexpand("../bin/gitea-runner/start.sh"))

  codeQualityConfigurationFilename = abspath(pathexpand("../etc/sonarqube-server/nginx/conf.d/default.conf"))
  codeQualityDeploymentFilename    = abspath(pathexpand("../etc/sonarqube-server/docker-compose.yml"))
  startCodeQualityScript           = abspath(pathexpand("../bin/sonarqube-server/start.sh"))
}

# Definition of the Gitea server instance.
resource "linode_instance" "server" {
  label           = var.settings.server.name
  tags            = var.settings.server.tags
  region          = var.settings.server.region
  type            = var.settings.server.type
  image           = var.settings.server.image
  private_ip      = true
  authorized_keys = [ linode_sshkey.default.ssh_key ]

  # Installs the required software.
  provisioner "remote-exec" {
    connection {
      host        = self.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "apt update",
      "apt -y upgrade",
      "hostnamectl set-hostname ${var.settings.server.name}",
      "apt -y install curl wget unzip zip dnsutils net-tools htop",
      "curl https://get.docker.com | sh -",
    ]
  }

  depends_on = [
    local_sensitive_file.certificate,
    local_sensitive_file.certificateKey,
    linode_sshkey.default
  ]
}

# Applies the Gitea server stack.
resource "null_resource" "applyServerStack" {
  # Triggers only when changed.
  triggers = {
    hash = "${filemd5(local.serverConfigurationFilename)}|${filemd5(local.serverDeploymentFilename)}|${filemd5(local.startServerScript)}|${filemd5(local.certificateFilename)}|${filemd5(local.certificateFilename)}"
  }

  # Default directories.
  provisioner "remote-exec" {
    connection {
      host        = linode_instance.server.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    inline = [
      "mkdir -p /root/${var.settings.server.name}/etc/nginx/conf.d",
      "mkdir -p /root/${var.settings.server.name}/etc/tls/certs",
      "mkdir -p /root/${var.settings.server.name}/etc/tls/private"
    ]
  }

  # Docker containers definition.
  provisioner "file" {
    connection {
      host        = linode_instance.server.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    source      = local.serverDeploymentFilename
    destination = "/root/${var.settings.server.name}/docker-compose.yml"
  }

  # Ingress files.
  provisioner "file" {
    connection {
      host        = linode_instance.server.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    source      = local.serverConfigurationFilename
    destination = "/root/${var.settings.server.name}/etc/nginx/conf.d/default.conf"
  }

  provisioner "file" {
    connection {
      host        = linode_instance.server.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    source      = local.certificateFilename
    destination = "/root/${var.settings.server.name}/etc/tls/certs/fullchain.pem"
  }

  provisioner "file" {
    connection {
      host        = linode_instance.server.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    source      = local.certificateKeyFilename
    destination = "/root/${var.settings.server.name}/etc/tls/private/privkey.pem"
  }

  provisioner "file" {
    connection {
      host        = linode_instance.server.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    source      = local.startServerScript
    destination = "/root/${var.settings.server.name}/start.sh"
  }

  # Start the stack.
  provisioner "remote-exec" {
    connection {
      host        = linode_instance.server.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    inline = [
      "cd /root/${var.settings.server.name}",
      "chmod +x *.sh",
      "./start.sh"
    ]
  }

  depends_on = [
    local_sensitive_file.certificate,
    local_sensitive_file.certificateKey,
    linode_instance.server
  ]
}

# Definition of the Gitea action runner instance.
resource "linode_instance" "runner" {
  label           = var.settings.runner.name
  tags            = var.settings.runner.tags
  region          = var.settings.runner.region
  type            = var.settings.runner.type
  image           = var.settings.runner.image
  private_ip      = true
  authorized_keys = [ linode_sshkey.default.ssh_key ]

  # Installs the required software.
  provisioner "remote-exec" {
    connection {
      host        = self.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "apt update",
      "apt -y upgrade",
      "hostnamectl set-hostname ${var.settings.runner.name}",
      "apt -y install curl wget unzip zip dnsutils net-tools htop",
      "curl https://get.docker.com | sh -",
      "mkdir -p /root/${var.settings.runner.name}"
    ]
  }

  depends_on = [ linode_instance.server ]
}

# Creates the environment file to run the actions runner.
resource "local_file" "runnerEnvironment" {
  count    = (length(var.settings.runner.registrationToken) == 0 ? 0 : 1)
  filename = local.runnerEnvironmentFilename
  content  = <<EOT
export DOCKER_REGISTRY_URL=ghcr.io
export DOCKER_REGISTRY_ID=fvilarinho
export BUILD_VERSION=latest
export GITEA_INSTANCE_URL=https://${var.settings.server.hostname}.${var.settings.general.domain}
export GITEA_RUNNER_REGISTRATION_TOKEN=${var.settings.runner.registrationToken}
export GITEA_RUNNER_NAME=${var.settings.runner.name}
export GITEA_RUNNER_LABELS=${var.settings.runner.name}
EOT
}

# Applies the Gitea action runner stack.
resource "null_resource" "applyRunnerStack" {
  # Triggers only when changed.
  triggers = {
    hash = "${filemd5(local.runnerImageFilename)}|${filemd5(local.startRunnerScript)}|${md5(var.settings.runner.registrationToken)}"
  }

  count = (length(var.settings.runner.registrationToken) == 0 ? 0 : 1)

  provisioner "file" {
    connection {
      host        = linode_instance.runner.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    source      = local.runnerEnvironmentFilename
    destination = "/root/${var.settings.runner.name}/.env"
  }

  # Startup script.
  provisioner "file" {
    connection {
      host        = linode_instance.runner.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    source      = local.startRunnerScript
    destination = "/root/${var.settings.runner.name}/start.sh"
  }

  # Start the stack.
  provisioner "remote-exec" {
    connection {
      host        = linode_instance.runner.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    inline = [
      "cd /root/${var.settings.runner.name}",
      "chmod +x *.sh",
      "./start.sh"
    ]
  }

  depends_on = [
    local_file.runnerEnvironment,
    linode_instance.runner
  ]
}

# Definition of the Sonarqube server instance.
resource "linode_instance" "codeQuality" {
  label           = var.settings.codeQuality.name
  tags            = var.settings.codeQuality.tags
  region          = var.settings.codeQuality.region
  type            = var.settings.codeQuality.type
  image           = var.settings.codeQuality.image
  private_ip      = true
  authorized_keys = [ linode_sshkey.default.ssh_key ]

  # Installs the required software.
  provisioner "remote-exec" {
    connection {
      host        = self.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "apt update",
      "apt -y upgrade",
      "hostnamectl set-hostname ${var.settings.codeQuality.name}",
      "apt -y install curl wget unzip zip dnsutils net-tools htop",
      "curl https://get.docker.com | sh -",
    ]
  }

  depends_on = [
    local_sensitive_file.certificate,
    local_sensitive_file.certificateKey,
    linode_sshkey.default
  ]
}

# Applies the Sonarqube server stack.
resource "null_resource" "applyCodeQualityStack" {
  # Triggers only when changed.
  triggers = {
    hash = "${filemd5(local.codeQualityConfigurationFilename)}|${filemd5(local.codeQualityDeploymentFilename)}|${filemd5(local.startCodeQualityScript)}|${filemd5(local.certificateFilename)}|${filemd5(local.certificateFilename)}"
  }

  # Default directories.
  provisioner "remote-exec" {
    connection {
      host        = linode_instance.codeQuality.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    inline = [
      "mkdir -p /root/${var.settings.codeQuality.name}/etc/nginx/conf.d",
      "mkdir -p /root/${var.settings.codeQuality.name}/etc/tls/certs",
      "mkdir -p /root/${var.settings.codeQuality.name}/etc/tls/private"
    ]
  }

  # Docker containers definition.
  provisioner "file" {
    connection {
      host        = linode_instance.codeQuality.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    source      = local.codeQualityDeploymentFilename
    destination = "/root/${var.settings.codeQuality.name}/docker-compose.yml"
  }

  # Ingress files.
  provisioner "file" {
    connection {
      host        = linode_instance.codeQuality.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    source      = local.codeQualityConfigurationFilename
    destination = "/root/${var.settings.codeQuality.name}/etc/nginx/conf.d/default.conf"
  }

  provisioner "file" {
    connection {
      host        = linode_instance.codeQuality.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    source      = local.certificateFilename
    destination = "/root/${var.settings.codeQuality.name}/etc/tls/certs/fullchain.pem"
  }

  provisioner "file" {
    connection {
      host        = linode_instance.codeQuality.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    source      = local.certificateKeyFilename
    destination = "/root/${var.settings.codeQuality.name}/etc/tls/private/privkey.pem"
  }

  provisioner "file" {
    connection {
      host        = linode_instance.codeQuality.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    source      = local.startCodeQualityScript
    destination = "/root/${var.settings.codeQuality.name}/start.sh"
  }

  # Start the stack.
  provisioner "remote-exec" {
    connection {
      host        = linode_instance.codeQuality.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    inline = [
      "cd /root/${var.settings.codeQuality.name}",
      "chmod +x *.sh",
      "./start.sh"
    ]
  }

  depends_on = [ linode_instance.server ]
}