variable "edgeGridAccountKey" {}

variable "edgeGridHost" {}

variable "edgeGridAccessToken" {}

variable "edgeGridClientToken" {}

variable "edgeGridClientSecret" {}

variable "accToken" {}

variable "compute" {
  default = {
    id     = "cicdzerotohero"
    image  = "linode/debian11"
    type   = "g7-premium-4"
    region = "br-gru"
    tags   = [ "devops" ]
  }
}

variable "stackscript" {
  default = {
    id          = "cicdzerotohero"
    description = "Initializes a Linode instance with Gitea and Jenkins."
    images      = [ "linode/debian11" ]
    filename    = "modules/provisioning/stackscript.sh"
  }
}