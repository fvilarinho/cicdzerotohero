# Fetches the object storage cluster information.
data "linode_object_storage_cluster" "default" {
  id = var.remoteBackend.region
}

# Creates the object storage bucket for the Terraform remote backend.
resource "linode_object_storage_bucket" "remotebackend" {
  cluster = data.linode_object_storage_cluster.default.id
  label   = var.remoteBackend.id
}