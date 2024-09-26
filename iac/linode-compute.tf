# Definition of the compute instance.
resource "linode_instance" "default" {
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
      private_key = tls_private_key.default.private_key_openssh
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
    tls_private_key.default,
    linode_sshkey.default,
    random_password.default
  ]
}

resource "null_resource" "applyStack" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "remote-exec" {
    connection {
      host        = linode_instance.default.ip_address
      user        = "root"
      private_key = tls_private_key.default.private_key_openssh
    }

    inline = [
      "mkdir -p /root/${var.settings.server.label}/etc/nginx/conf.d",
      "mkdir -p /root/${var.settings.server.label}/etc/ssl/certs",
      "mkdir -p /root/${var.settings.server.label}/etc/ssl/private"
    ]
  }

  provisioner "file" {
    connection {
      host        = linode_instance.default.ip_address
      user        = "root"
      private_key = tls_private_key.default.private_key_openssh
    }

    source      = "docker-compose.yml"
    destination = "/root/${var.settings.server.label}/docker-compose.yml"
  }

  provisioner "file" {
    connection {
      host        = linode_instance.default.ip_address
      user        = "root"
      private_key = tls_private_key.default.private_key_openssh
    }

    source      = "../etc/nginx/conf.d/default.conf"
    destination = "/root/${var.settings.server.label}/etc/nginx/conf.d/default.conf"
  }

  provisioner "file" {
    connection {
      host        = linode_instance.default.ip_address
      user        = "root"
      private_key = tls_private_key.default.private_key_openssh
    }

    source      = "../etc/ssl/certs/fullchain.pem"
    destination = "/root/${var.settings.server.label}/etc/ssl/certs/fullchain.pem"
  }

  provisioner "file" {
    connection {
      host        = linode_instance.default.ip_address
      user        = "root"
      private_key = tls_private_key.default.private_key_openssh
    }

    source      = "../etc/ssl/private/privkey.pem"
    destination = "/root/${var.settings.server.label}/etc/ssl/private/privkey.pem"
  }

  provisioner "remote-exec" {
    connection {
      host        = linode_instance.default.ip_address
      user        = "root"
      private_key = tls_private_key.default.private_key_openssh
    }

    inline = [ "cd /root/${var.settings.server.label} ; docker compose up -d"]
  }

  depends_on = [ linode_instance.default ]
}