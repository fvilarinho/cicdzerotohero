terraform {
  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
}

provider "linode" {
  token = var.linode_token
}

resource "linode_sshkey" "git" {
  label   = var.git_label
  ssh_key = chomp(file(var.git_public_key))
}

resource "linode_sshkey" "jenkins" {
  label   = var.jenkins_label
  ssh_key = chomp(file(var.jenkins_public_key))
}

resource "linode_stackscript" "git" {
  label = var.git_label
  description = "Install a GIT instance (GOGS) for source code versioning."
  script = <<EOF
#!/bin/bash
apt -y update
apt -y upgrade
apt -y install ca-certificates curl wget dnsutils net-tools vim gnupg2
wget -qO- https://dl.packager.io/srv/gogs/gogs/key | apt-key add -
wget -O /etc/apt/sources.list.d/gogs.list https://dl.packager.io/srv/gogs/gogs/main/installer/debian/11.repo
apt -y update
apt -y install gogs
cp /etc/default/gogs /tmp
sed -i -e 's|6000|3000|g' /tmp/gogs
cp /tmp/gogs /etc/default
rm /tmp/gogs
cp /etc/ssh/sshd_config /tmp
sed -i -e 's|PasswordAuthentication yes|PasswordAuthentication no|g' /tmp/sshd_config
cp /tmp/sshd_config /etc/ssh
rm /tmp/sshd_config
systemctl restart ssh
systemctl restart gogs
hostnamectl set-hostname ${var.git_label}
EOF
  images = [ var.git_image ]
  rev_note = "Initial version."
}

resource "linode_instance" "git" {
  label = var.git_label
  region = var.git_region
  image = var.git_image
  type = var.git_type
  private_ip = true
  stackscript_id = linode_stackscript.git.id
  authorized_keys = [ linode_sshkey.git.ssh_key ]

  connection {
    type = "ssh"
    agent = false
    host = self.ip_address
    user = "root"
    private_key = chomp(file(var.git_private_key))
  }

  provisioner "remote-exec" {
    inline = [
      "while [ -z \"$(netstat -an |grep :3000)\" ]; do sleep 1; done",
      "echo",
      "echo Installation is done! Please access http://${self.ip_address}:3000 and start the setup!",
      "echo"
    ]
  }
}

resource "linode_stackscript" "jenkins" {
  label = var.jenkins_label
  description = "Install a Jenkins instance to build CI/CD pipelines."
  script = <<EOF
#!/bin/bash
apt -y update
apt -y upgrade
apt -y install ca-certificates curl wget dnsutils net-tools vim gnupg openjdk-11-jdk default-jre apt-transport-https
wget -qO- https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
echo "deb https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list
apt -y update
apt -y install jenkins
cp /etc/ssh/sshd_config /tmp
sed -i -e 's|PasswordAuthentication yes|PasswordAuthentication no|g' /tmp/sshd_config
cp /tmp/sshd_config /etc/ssh
rm /tmp/sshd_config
systemctl restart ssh
hostnamectl set-hostname ${var.jenkins_label}
EOF
  images = [ var.jenkins_image ]
  rev_note = "Initial version."
}

resource "linode_instance" "jenkins" {
  label = var.jenkins_label
  region = var.jenkins_region
  image = var.jenkins_image
  type = var.jenkins_type
  private_ip = true
  stackscript_id = linode_stackscript.jenkins.id
  authorized_keys = [ linode_sshkey.jenkins.ssh_key ]

  connection {
    type = "ssh"
    agent = false
    host = self.ip_address
    user = "root"
    private_key = chomp(file(var.jenkins_private_key))
  }

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /var/lib/jenkins/secrets/initialAdminPassword ]; do sleep 1; done",
      "echo",
      "echo -n Initial Jenkins Admin Password:",
      "cat /var/lib/jenkins/secrets/initialAdminPassword",
      "echo",
      "echo Installation is done! Please access http://${self.ip_address}:8080 and start the setup!",
      "echo"
    ]
  }
}