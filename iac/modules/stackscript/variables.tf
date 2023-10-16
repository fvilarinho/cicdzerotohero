variable "credentialsFilename" {
  type    = string
  default = "modules/stackscript/.credentials"
}

variable "credentialsSectionName" {
  type    = string
  default = "linode"
}

variable "stackscript" {
  default = {
    id          = "cicdzerotohero"
    description = "Initializes a Linode instance with Gitea and Jenkins."
    images      = [ "linode/debian10", "linode/debian11", "linode/debian12" ]
    filename    = "modules/stackscript/stackscript.sh"
  }
}