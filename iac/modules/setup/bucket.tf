data "linode_object_storage_cluster" "default" {
  id = var.remoteBackend.region
}

resource "linode_object_storage_bucket" "remotebackend" {
  cluster = data.linode_object_storage_cluster.default.id
  label   = var.remoteBackend.id
}