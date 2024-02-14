# Fetches the object storage cluster information.
data "linode_object_storage_cluster" "remoteBackend" {
  id = local.settings.remoteBackend.region
}

# Creates the object storage bucket for the Terraform remote backend.
resource "linode_object_storage_bucket" "remoteBackend" {
  cluster    = data.linode_object_storage_cluster.remoteBackend.id
  label      = local.settings.remoteBackend.id
  depends_on = [ data.linode_object_storage_cluster.remoteBackend ]
}