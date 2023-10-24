# Providers definition.
terraform {
  required_providers {
    linode = {
      source = "linode/linode"
    }
    local = {
      source = "hashicorp/local"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
}

# Akamai Connected Cloud provider definition.
provider "linode" {
  token = var.accToken
}