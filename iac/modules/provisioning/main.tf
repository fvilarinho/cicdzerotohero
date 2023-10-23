# Providers definition.
terraform {
  required_providers {
    linode = {
      source = "linode/linode"
    }
    null = {
      source = "hashicorp/null"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

# Akamai Connected Cloud provider definition.
provider "linode" {
  token = var.accToken
}