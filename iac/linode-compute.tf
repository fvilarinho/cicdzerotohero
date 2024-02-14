# Definition of the initial password for the compute instance.
resource "random_password" "default" {
  length = 15
}

# Definition of the compute instance.
resource "linode_instance" "default" {
  label            = local.settings.compute.label
  tags             = local.settings.tags
  region           = local.settings.compute.region
  type             = local.settings.compute.type
  image            = local.settings.stackScript.images[0]
  root_pass        = random_password.default.result
  authorized_keys  = [ linode_sshkey.default.ssh_key ]
  stackscript_id   = linode_stackscript.default.id
  stackscript_data = {
    HOSTNAME               = local.settings.compute.label
    PRIVATE_KEY            = tls_private_key.default.private_key_openssh
    EDGEGRID_ACCOUNT_KEY   = var.edgeGridAccountKey
    EDGEGRID_HOST          = var.edgeGridHost
    EDGEGRID_ACCESS_TOKEN  = var.edgeGridAccessToken
    EDGEGRID_CLIENT_TOKEN  = var.edgeGridClientToken
    EDGEGRID_CLIENT_SECRET = var.edgeGridClientSecret
    ACC_TOKEN              = var.accToken
    ACC_ACCESS_KEY         = linode_object_storage_key.remoteBackend.access_key
    ACC_SECRET_KEY         = linode_object_storage_key.remoteBackend.secret_key
  }

  depends_on = [
    random_password.default,
    linode_stackscript.default
  ]
}