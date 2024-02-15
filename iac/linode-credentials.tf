# Definition of local variables.
locals {
  privateKeyFilename = pathexpand(var.privateKeyFilename)
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

# Creates the SSH public key.
resource "linode_sshkey" "default" {
  label      = local.settings.id
  ssh_key    = chomp(tls_private_key.default.public_key_openssh)
  depends_on = [ tls_private_key.default ]
}

# Creates the Terraform remote backend for state management in the Akamai Connected Cloud object storage.
resource "linode_object_storage_key" "remoteBackend" {
  label = local.settings.id

  bucket_access {
    bucket_name = local.settings.remoteBackend.id
    cluster     = data.linode_object_storage_cluster.remoteBackend.id
    permissions = "read_write"
  }

  depends_on = [ linode_object_storage_bucket.remoteBackend ]
}
