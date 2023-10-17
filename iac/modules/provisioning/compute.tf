resource "random_password" "cicdzerotohero" {
  length = 15
}

resource "linode_instance" "cicdzerotohero" {
  label            = var.compute.id
  region           = var.compute.region
  type             = var.compute.type
  image            = var.compute.image
  root_pass        = random_password.cicdzerotohero.result
  stackscript_id   = linode_stackscript.cicdzerotohero.id
  stackscript_data = {
    EDGEGRID_HOST          = var.edgeGridHost
    EDGEGRID_ACCESS_TOKEN  = var.edgeGridAccessToken
    EDGEGRID_CLIENT_TOKEN  = var.edgeGridClientToken
    EDGEGRID_CLIENT_SECRET = var.edgeGridClientSecret
    ACC_TOKEN              = var.accToken
    REMOTEBACKEND_ID       = var.compute.id
    REMOTEBACKEND_REGION   = "${var.compute.region}-1"
  }

  depends_on = [
    random_password.cicdzerotohero,
    linode_stackscript.cicdzerotohero
  ]
}