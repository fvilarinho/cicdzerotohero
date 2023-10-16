terraform {
  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
}

provider "linode" {
  config_path = var.credentialsFilename
}

resource "linode_stackscript" "cicdzerotohero" {
  label       = var.stackscript.id
  description = var.stackscript.description
  script      = chomp(file(var.stackscript.filename))
  images      = var.stackscript.images
}