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

variable "remoteBackend" {
  default = {
    id     = "fvilarin-devops"
    region = "us-east-1"
  }
}