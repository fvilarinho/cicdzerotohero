module "provisioning" {
  source               = "./modules/provisioning"
  edgeGridAccountKey   = var.edgeGridAccountKey
  edgeGridHost         = var.edgeGridHost
  edgeGridAccessToken  = var.edgeGridAccessToken
  edgeGridClientToken  = var.edgeGridClientToken
  edgeGridClientSecret = var.edgeGridClientSecret
  accToken             = var.accToken
}

module "setup" {
  source               = "./modules/setup"
  edgeGridAccountKey   = var.edgeGridAccountKey
  edgeGridHost         = var.edgeGridHost
  edgeGridAccessToken  = var.edgeGridAccessToken
  edgeGridClientToken  = var.edgeGridClientToken
  edgeGridClientSecret = var.edgeGridClientSecret
  accToken             = var.accToken
  remoteBackendId      = var.remoteBackendId
  remoteBackendRegion  = var.remoteBackendRegion
}