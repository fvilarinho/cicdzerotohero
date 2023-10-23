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

# Akamai EdgeGrid credentials filename.
variable "edgeGridCredentialsFilename" {
  default = "~/.edgerc"
}
# Akamai Connected Cloud Token.
variable "accToken" {}

# Akamai Connected Cloud credentials filename.
variable "accCredentialsFilename" {
  default = "~/.aws/credentials"
}

# Terraform remote backend definition.
variable "remoteBackend" {
  default = {
    id     = "fvilarin-devops"
    region = "us-east-1"
  }
}