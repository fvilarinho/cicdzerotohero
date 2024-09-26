# Definition of local variables.
locals {
  privateKeyFilename = abspath(pathexpand(".id_rsa"))
  publicKeyFilename = abspath(pathexpand(".id_rsa.pub"))
}

# Creates the SSH private key.
resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

# Saves the SSH private key file.
resource "local_sensitive_file" "privateKey" {
  filename        = local.privateKeyFilename
  content         = tls_private_key.default.private_key_openssh
  file_permission = "600"
  depends_on      = [ tls_private_key.default ]
}

# Saves the SSH public key file.
resource "local_sensitive_file" "publicKey" {
  filename        = local.publicKeyFilename
  content         = tls_private_key.default.public_key_openssh
  file_permission = "600"
  depends_on      = [ tls_private_key.default ]
}

# Creates the SSH public key.
resource "linode_sshkey" "default" {
  label      = var.credentials.label
  ssh_key    = chomp(tls_private_key.default.public_key_openssh)
  depends_on = [ tls_private_key.default ]
}

# Definition of the initial password for the compute instance.
resource "random_password" "default" {
  length = 15
}