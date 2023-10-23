variable "edgeGridAccountKey" {}

variable "edgeGridHost" {}

variable "edgeGridAccessToken" {}

variable "edgeGridClientToken" {}

variable "edgeGridClientSecret" {}

variable "edgeGridCredentialsFilename" {
  default = "~/.edgerc"
}

variable "accToken" {}

variable "accCredentialsFilename" {
  default = "~/.aws/credentials"
}

variable "remoteBackendId" {}

variable "remoteBackendRegion" {}