module "provisioning" {
  source               = "./modules/provisioning"
  edgeGridHost         = var.edgeGridHost
  edgeGridAccessToken  = var.edgeGridAccessToken
  edgeGridClientToken  = var.edgeGridClientToken
  edgeGridClientSecret = var.edgeGridClientSecret
  accToken             = var.accToken
}

module "setup" {
  source              = "./modules/setup"
  accToken            = var.accToken
  remoteBackendId     = var.remoteBackendId
  remoteBackendRegion = var.remoteBackendRegion
}