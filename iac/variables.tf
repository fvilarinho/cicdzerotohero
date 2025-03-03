variable "credentials" {
  default = {
    akamai = {
      linode = {
        token = "<token>"
      }

      edgegrid = {
        host         = "<host>"
        accessToken  = "<accessToken>"
        clientToken  = "<clientToken>"
        clientSecret = "<clientSecret>"
      }
    }
  }
}

variable "settings" {
  default = {
    general = {
      label  = "cicdzerotohero"
      email  = "<your-email>"
      domain = "<your-domain>"
    }

    akamai = {
      property = {
        account  = "<account>"
        contract = "<contract>"
        group    = "<group>"
        product  = "<product>"
        name     = "gitea"
      }
    }

    server = {
      name       = "gitea-server"
      tags       = ["devops", "demo"]
      region     = "br-gru"
      type       = "g6-standard-4"
      image      = "linode/debian11"
      allowedIps = {
        ipv4 = [ "0.0.0.0/0" ]
        ipv6 = []
      }
    }

    runner = {
      name              = "gitea-runner"
      tags              = ["devops", "demo"]
      region            = "br-gru"
      type              = "g6-standard-4"
      image             = "linode/debian11"
      registrationToken = ""
      allowedIps        = {
        ipv4 = [ "0.0.0.0/0" ]
        ipv6 = []
      }
    }
  }
}