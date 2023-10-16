module "stackscript" {
  source = "./modules/stackscript"
}

module "remotebackend" {
  source              = "./modules/remotebackend"
  accToken            = var.accToken
  remoteBackendId     = var.remoteBackendId
  remoteBackendRegion = var.remoteBackendRegion
}