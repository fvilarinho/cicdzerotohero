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
    id          = "CI/CD Zero to Hero"
    description = "Initializes an compute instance with Gitea and Jenkins running in containers."
    public      = true
    images      = [ "linode/debian11" ]
    filename    = "modules/provisioning/stackscript.sh"
  }
}