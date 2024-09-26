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

    server = {
      label  = "gitea-server"
      tags = ["cicd", "devops"]
      region = "br-gru"
      type   = "g6-standard-4"
      image  = "linode/debian11"
    }

    runner = {
      label  = "gitea-runner"
      tags = ["cicd", "devops"]
      region = "br-gru"
      type   = "g6-standard-4"
      image  = "linode/debian11"
    }
  }
}