terraform {
  required_providers {
    linode = {
      source = "linode/linode"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
}

provider "linode" {
  config_path    = pathexpand(var.credentialsFilename)
  config_profile = var.credentialsSectionName
}

resource "linode_stackscript" "cicdzerotohero" {
  label       = "cicdzerotohero"
  description = "Initializes a Linode instance with Gitea and Jenkins."
  script      = chomp(file("stackscript.sh"))
  images      = [ "linode/debian11" ]
}