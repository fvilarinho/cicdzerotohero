module "stackscript" {
  source               = "./modules/stackscript"
  edgeGridHost         = var.edgeGridHost
  edgeGridAccessToken  = var.edgeGridAccessToken
  edgeGridClientToken  = var.edgeGridClientToken
  edgeGridClientSecret = var.edgeGridClientSecret
  accToken             = var.accToken
}

module "remotebackend" {
  source              = "./modules/remotebackend"
  accToken            = var.accToken
  remoteBackendId     = var.remoteBackendId
  remoteBackendRegion = var.remoteBackendRegion
}