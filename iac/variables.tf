variable "settings" {
  default = {
    general = {
      label  = "cicdzerotohero"
      email  = "<your-email>"
      domain = "<your-domain>"
    }

    server = {
      label  = "gitea-server"
      tags = ["cicd", "server", "devops"]
      region = "br-gru"
      type   = "g6-standard-4"
      image  = "linode/debian11"
    }

    runner = {
      label             = "gitea-runner"
      tags              = ["cicd", "runner", "devops"]
      region            = "br-gru"
      type              = "g6-standard-4"
      image             = "linode/debian11"
      registrationToken = ""
    }
  }
}