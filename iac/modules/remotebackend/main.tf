terraform {
  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
}

provider "linode" {
  token = var.accToken
}

data "linode_object_storage_cluster" "default" {
  id = var.remotebackend.region
}

resource "linode_object_storage_bucket" "remotebackend" {
  cluster = data.linode_object_storage_cluster.default.id
  label   = var.remotebackend.id
}

resource "linode_object_storage_key" "remotebackend" {
  label = var.remotebackend.id

  bucket_access {
    bucket_name = var.remotebackend.id
    cluster     = data.linode_object_storage_cluster.default.id
    permissions = "read_write"
  }
}

resource "local_sensitive_file" "accCredentials" {
  filename = pathexpand("~/.aws/credentials")
  content  = <<EOT
[default]
aws_access_key_id = ${linode_object_storage_key.remotebackend.access_key}
aws_secret_access_key=${linode_object_storage_key.remotebackend.secret_key}"
EOT
}