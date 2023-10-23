# Akamai EdgeGrid Account Key.
variable "edgeGridAccountKey" {}

# Akamai EdgeGrid Hostname.
variable "edgeGridHost" {}

# Akamai EdgeGrid Access Token.
variable "edgeGridAccessToken" {}

# Akamai EdgeGrid Client Token.
variable "edgeGridClientToken" {}

# Akamai EdgeGrid Client Secret.
variable "edgeGridClientSecret" {}

# Akamai Connected Cloud Token.
variable "accToken" {}

# Definition of the compute instance.
variable "compute" {
  default = {
    id     = "cicdzerotohero"
    image  = "linode/debian11"
    type   = "g7-premium-4"
    region = "br-gru"
    tags   = [ "devops" ]
  }
}

# Definition of the Stack Script.
variable "stackscript" {
  default = {
    id          = "cicdzerotohero"
    description = "Initializes a Linode instance with Gitea and Jenkins."
    images      = [ "linode/debian11" ]
    filename    = "modules/provisioning/stackscript.sh"
  }
}