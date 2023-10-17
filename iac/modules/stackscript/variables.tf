variable "edgeGridHost" {
}

variable "edgeGridAccessToken" {
}

variable "edgeGridClientToken" {
}

variable "edgeGridClientSecret" {
}

variable "accToken" {
}

variable "stackscript" {
  default = {
    id          = "cicdzerotohero"
    description = "Initializes a Linode instance with Gitea and Jenkins."
    images      = [ "linode/debian11" ]
    filename    = "modules/stackscript/stackscript.sh"
  }
}

variable "instance" {
  default = {
    id     = "cicdzerotohero"
    image  = "linode/debian11"
    type   = "g6-standard-2"
    region = "br-gru"
  }
}