resource "linode_object_storage_key" "remotebackend" {
  label = var.remoteBackendId

  bucket_access {
    bucket_name = var.remoteBackendId
    cluster     = data.linode_object_storage_cluster.default.id
    permissions = "read_write"
  }

  depends_on = [ linode_object_storage_bucket.remotebackend ]
}

resource "local_sensitive_file" "accCredentials" {
  filename = pathexpand(var.remoteBackendCredentialsFilename)
  content  = <<EOT
[default]
token = ${var.accToken}
aws_access_key_id = ${linode_object_storage_key.remotebackend.access_key}
aws_secret_access_key=${linode_object_storage_key.remotebackend.secret_key}
EOT

  depends_on = [ linode_object_storage_key.remotebackend ]
}