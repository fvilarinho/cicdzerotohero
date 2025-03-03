variable "credentials" {
  default = {
    akamai = {
      linode = {
        token = "<token>"
      }

      edgegrid = {
        account      = "<account>"
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
      name     = "cicdzerotohero"
      email    = "<your-email>"
      domain   = "<your-domain>"
      contract = "<contract>"
      group    = "<group>"
      product  = "<product>"
    }

    server = {
      name       = "gitea-server"
      hostname   = "git"
      tags       = ["devops", "demo"]
      region     = "<region>"
      type       = "<type>"
      image      = "<image>"
      allowedIps = {
        ipv4 = [ "0.0.0.0/0" ]
        ipv6 = []
      }
    }

    runner = {
      name              = "gitea-runner"
      hostname          = "runner"
      tags              = ["devops", "demo"]
      region            = "<region>"
      type              = "<type>"
      image             = "<image>"
      registrationToken = ""
      allowedIps        = {
        ipv4 = [ "0.0.0.0/0" ]
        ipv6 = []
      }
    }

    codeQuality = {
      name     = "sonarqube-server"
      hostname = "codequality"
      tags = ["devops", "demo"]
      region   = "<region>"
      type     = "<type>"
      image    = "<image>"
      allowedIps = {
        ipv4 = [
          "72.246.44.0/24",
          "179.100.0.229/32",
          "172.233.14.141/32",
          "104.64.0.0/10",
          "118.214.0.0/16",
          "173.222.0.0/15",
          "184.24.0.0/13",
          "184.50.0.0/15",
          "184.84.0.0/14",
          "2.16.0.0/13",
          "23.0.0.0/12",
          "23.192.0.0/11",
          "23.32.0.0/11",
          "23.64.0.0/14",
          "23.72.0.0/13",
          "69.192.0.0/16",
          "72.246.0.0/15",
          "88.221.0.0/16",
          "92.122.0.0/15",
          "95.100.0.0/15",
          "96.16.0.0/15",
          "96.6.0.0/15"
        ]
        ipv6 = []
      }
    }
  }
}