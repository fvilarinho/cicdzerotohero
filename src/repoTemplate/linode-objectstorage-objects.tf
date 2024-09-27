# List all available content of the website.
locals {
  contentDirectory = abspath(pathexpand("content"))
  availablePages = fileset(local.contentDirectory, "*.html")
  availableStyles = fileset(local.contentDirectory, "styles/*")
  availableScripts = fileset(local.contentDirectory, "scripts/*")
  availableImages = fileset(local.contentDirectory, "images/*")
}

# Upload pages.
resource "linode_object_storage_object" "availablePages" {
  for_each       = { for file in local.availablePages : file => { bucket: element(split("/", file), 0) } }
  region         = linode_object_storage_bucket.default.region
  bucket         = linode_object_storage_bucket.default.label
  key            = each.key
  content_base64 = filebase64("${local.contentDirectory}/${each.key}")
  content_type   = "text/html"
  acl            = "public-read"
  access_key     = linode_object_storage_key.default.access_key
  secret_key     = linode_object_storage_key.default.secret_key
  depends_on     = [ linode_object_storage_key.default ]
}

# Upload styles.
resource "linode_object_storage_object" "availableStyles" {
  for_each       = { for file in local.availableStyles : file => { bucket: element(split("/", file), 0) } }
  region         = linode_object_storage_bucket.default.region
  bucket         = linode_object_storage_bucket.default.label
  key            = each.key
  content_base64 = filebase64("${local.contentDirectory}/${each.key}")
  content_type   = "text/css"
  acl            = "public-read"
  access_key     = linode_object_storage_key.default.access_key
  secret_key     = linode_object_storage_key.default.secret_key
  depends_on     = [ linode_object_storage_key.default ]
}

# Upload scripts.
resource "linode_object_storage_object" "availableScripts" {
  for_each       = { for file in local.availableScripts : file => { bucket: element(split("/", file), 0) } }
  region         = linode_object_storage_bucket.default.region
  bucket         = linode_object_storage_bucket.default.label
  key            = each.key
  content_base64 = filebase64("${local.contentDirectory}/${each.key}")
  content_type   = "text/javascript"
  acl            = "public-read"
  access_key     = linode_object_storage_key.default.access_key
  secret_key     = linode_object_storage_key.default.secret_key
  depends_on     = [ linode_object_storage_key.default ]
}

# Upload images.
resource "linode_object_storage_object" "availableImages" {
  for_each       = { for file in local.availableImages : file => { bucket: element(split("/", file), 0) } }
  region         = linode_object_storage_bucket.default.region
  bucket         = linode_object_storage_bucket.default.label
  key            = each.key
  content_base64 = filebase64("${local.contentDirectory}/${each.key}")
  acl            = "public-read"
  access_key     = linode_object_storage_key.default.access_key
  secret_key     = linode_object_storage_key.default.secret_key
  depends_on     = [ linode_object_storage_key.default ]
}