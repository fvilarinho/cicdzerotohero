# Definition of local variables.
locals {
  privateKeyFilename = abspath(pathexpand("~/.ssh/id_rsa"))
  publicKeyFilename = abspath(pathexpand("~/.ssh/id_rsa.pub"))
}

# Creates the SSH public key.
resource "linode_sshkey" "default" {
  label   = var.credentials.label
  ssh_key = chomp(file(local.publicKeyFilename))
}

# Definition of the initial password for the compute instance.
resource "random_password" "default" {
  length = 15
}