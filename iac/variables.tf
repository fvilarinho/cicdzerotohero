variable "credentials" {
  default = {
    label  = "cicdzerotohero"
    linode = {
      token = "<token>"
    }
  }
}

variable "settings" {
  default = {
    general = {
      email  = "<your-email>"
      domain = "<your-domain>"
    }

    compute = {
      label  = "cicdzerotohero"
      tags = ["cici", "devops"]
      region = "br-gru"
      type   = "g6-standard-4"
      image  = "linode/debian11"
    }
  }
}