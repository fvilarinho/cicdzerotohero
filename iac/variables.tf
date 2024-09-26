variable "credentials" {
  default = {
    linode = {
      token = "<token>"
    }
  }
}

variable "settings" {
  default = {
    label  = "cicdzerotohero"
    tags   = [ "cici", "gitea", "devops" ]
    region = "br-gru"
    type   = "g6-standard-4"
    image  = "linode/debian11"
  }
}