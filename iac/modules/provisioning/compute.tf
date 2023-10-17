resource "random_password" "cicdzerotohero" {
  length = 15
}

resource "linode_instance" "cicdzerotohero" {
  label            = var.instance.id
  region           = var.instance.region
  type             = var.instance.type
  image            = var.instance.image
  root_pass        = random_password.cicdzerotohero.result
  stackscript_id   = linode_stackscript.cicdzerotohero.id
  stackscript_data = {
    EDGEGRID_HOST          = var.edgeGridHost
    EDGEGRID_ACCESS_TOKEN  = var.edgeGridAccessToken
    EDGEGRID_CLIENT_TOKEN  = var.edgeGridClientToken
    EDGEGRID_CLIENT_SECRET = var.edgeGridClientSecret
    ACC_TOKEN              = var.accToken
    REMOTEBACKEND_ID       = var.instance.id
    REMOTEBACKEND_REGION   = "${var.instance.region}-1"
  }

  depends_on = [
    random_password.cicdzerotohero,
    linode_stackscript.cicdzerotohero
  ]
}