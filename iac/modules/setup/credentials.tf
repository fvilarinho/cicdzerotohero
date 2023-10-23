# Creates the terraform remote backend using the Akamai Connected Cloud object storage.
resource "linode_object_storage_key" "remotebackend" {
  label = var.remoteBackend.id

  bucket_access {
    bucket_name = var.remoteBackend.id
    cluster     = data.linode_object_storage_cluster.default.id
    permissions = "read_write"
  }

  depends_on = [ linode_object_storage_bucket.remotebackend ]
}

# Creates the Akamai EdgeGrid credentials filename.
resource "local_sensitive_file" "edgeGridCredentials" {
  filename        = pathexpand(var.edgeGridCredentialsFilename)
  file_permission = "644"
  content         = <<EOT
[default]
account_key   = ${var.edgeGridAccountKey}
host          = ${var.edgeGridHost}
access_token  = ${var.edgeGridAccessToken}
client_token  = ${var.edgeGridClientToken}
client_secret = ${var.edgeGridClientSecret}
EOT
}

# Creates the Akamai Connected Cloud credentials filename.
resource "local_sensitive_file" "accCredentials" {
  filename        = pathexpand(var.accCredentialsFilename)
  file_permission = "644"
  content         = <<EOT
[default]
token                 = ${var.accToken}
aws_access_key_id     = ${linode_object_storage_key.remotebackend.access_key}
aws_secret_access_key = ${linode_object_storage_key.remotebackend.secret_key}
EOT

  depends_on = [ linode_object_storage_key.remotebackend ]
}