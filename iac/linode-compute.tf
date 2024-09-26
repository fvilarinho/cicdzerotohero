locals {
  runnerEnvironmentFilename = abspath(pathexpand("../etc/runner/.env"))
  startRunnerScript         = abspath(pathexpand("../bin/runner/start.sh"))
}

# Definition of the compute instance.
resource "linode_instance" "server" {
  label           = var.settings.server.label
  tags            = var.settings.server.tags
  region          = var.settings.server.region
  type            = var.settings.server.type
  image           = var.settings.server.image
  authorized_keys = [ linode_sshkey.default.ssh_key ]

  provisioner "remote-exec" {
    connection {
      host        = self.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    inline = [
      "apt update",
      "apt -y upgrade",
      "hostnamectl set-hostname ${var.settings.server.label}",
      "apt -y install curl wget unzip zip dnsutils net-tools htop",
      "curl https://get.docker.com | sh -",
    ]
  }

  depends_on = [
    local_sensitive_file.certificate,
    local_sensitive_file.certificateKey,
    linode_sshkey.default,
    random_password.default
  ]
}

resource "null_resource" "applyServerStack" {
  provisioner "remote-exec" {
    connection {
      host        = linode_instance.server.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    inline = [
      "mkdir -p /root/${var.settings.server.label}/etc/nginx/conf.d",
      "mkdir -p /root/${var.settings.server.label}/etc/ssl/certs",
      "mkdir -p /root/${var.settings.server.label}/etc/ssl/private"
    ]
  }

  provisioner "file" {
    connection {
      host        = linode_instance.server.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    source      = "docker-compose.yml"
    destination = "/root/${var.settings.server.label}/docker-compose.yml"
  }

  provisioner "file" {
    connection {
      host        = linode_instance.server.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    source      = "../etc/nginx/conf.d/default.conf"
    destination = "/root/${var.settings.server.label}/etc/nginx/conf.d/default.conf"
  }

  provisioner "file" {
    connection {
      host        = linode_instance.server.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    source      = local.certificateFilename
    destination = "/root/${var.settings.server.label}/etc/ssl/certs/fullchain.pem"
  }

  provisioner "file" {
    connection {
      host        = linode_instance.server.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    source      = local.certificateKeyFilename
    destination = "/root/${var.settings.server.label}/etc/ssl/private/privkey.pem"
  }

  provisioner "remote-exec" {
    connection {
      host        = linode_instance.server.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    inline = [ "cd /root/${var.settings.server.label} ; docker compose up -d"]
  }

  depends_on = [ linode_instance.server ]
}

resource "linode_instance" "runner" {
  label           = var.settings.runner.label
  tags            = var.settings.runner.tags
  region          = var.settings.runner.region
  type            = var.settings.runner.type
  image           = var.settings.runner.image
  authorized_keys = [ linode_sshkey.default.ssh_key ]

  provisioner "remote-exec" {
    connection {
      host        = self.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    inline = [
      "apt update",
      "apt -y upgrade",
      "hostnamectl set-hostname ${var.settings.runner.label}",
      "apt -y install curl wget unzip zip dnsutils net-tools htop",
      "curl https://get.docker.com | sh -",
      "mkdir -p /root/${var.settings.runner.label}"
    ]
  }

  depends_on = [ linode_instance.server ]
}

resource "local_file" "runnerEnvironment" {
  count    = (length(var.settings.runner.registrationToken) == 0 ? 0 : 1)
  filename = local.runnerEnvironmentFilename
  content  = <<EOT
GITEA_INSTANCE_URL=https://gitea.${var.settings.general.domain}
GITEA_RUNNER_REGISTRATION_TOKEN=${var.settings.runner.registrationToken}
GITEA_RUNNER_NAME=${var.settings.runner.label}
GITEA_RUNNER_LABELS=${var.settings.runner.label}
EOT
}

resource "null_resource" "applyRunnerStack" {
  count = (length(var.settings.runner.registrationToken) == 0 ? 0 : 1)

  provisioner "file" {
    connection {
      host        = linode_instance.runner.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    source      = local.runnerEnvironmentFilename
    destination = "/root/${var.settings.runner.label}/.env"
  }

  provisioner "file" {
    connection {
      host        = linode_instance.runner.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    source      = local.startRunnerScript
    destination = "/root/${var.settings.runner.label}/start.sh"
  }

  provisioner "remote-exec" {
    connection {
      host        = linode_instance.runner.ip_address
      user        = "root"
      private_key = chomp(file(local.privateKeyFilename))
    }

    inline = [
      "cd /root/${var.settings.runner.label}",
      "chmod +x *.sh",
      "./start.sh"
    ]
  }

  depends_on = [
    linode_instance.runner,
    local_file.runnerEnvironment
  ]
}