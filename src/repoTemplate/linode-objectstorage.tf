# Definition of the object storage bucket. This will be the origin hostname.
resource "linode_object_storage_bucket" "default" {
  label  = var.propertyName
  region = "br-gru"
  acl    = "public-read"
}

# Definition of the object storage access key.
resource "linode_object_storage_key" "default" {
  label = var.propertyName

  bucket_access {
    region      = linode_object_storage_bucket.default.region
    bucket_name = linode_object_storage_bucket.default.label
    permissions = "read_write"
  }

  depends_on = [ linode_object_storage_bucket.default ]
}