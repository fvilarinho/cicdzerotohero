# Required variables.
locals {
  privateKeyFilename = abspath(pathexpand("~/.ssh/id_rsa"))
  publicKeyFilename  = abspath(pathexpand("~/.ssh/id_rsa.pub"))
}

# Creates the SSH public key.
resource "linode_sshkey" "default" {
  label   = var.settings.general.label
  ssh_key = chomp(file(local.publicKeyFilename))
}