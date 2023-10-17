data "linode_object_storage_cluster" "default" {
  id = var.remoteBackendRegion
}

resource "linode_object_storage_bucket" "remotebackend" {
  cluster = data.linode_object_storage_cluster.default.id
  label   = var.remoteBackendId
}