# Terraform definition.
terraform {
  # Required providers definition.
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

# Definition of local variables.
locals {
  settings = jsondecode(file(pathexpand(var.settingsFilename)))
}