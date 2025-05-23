# Terraform definition.
terraform {
  # Stores the provisioning state in Akamai Cloud Computing Object Storage (Please change to use your own).
  backend "s3" {
    bucket                      = "fvilarin-devops"
    key                         = "cicdzerotohero.tfstate"
    region                      = "us-east-1"
    endpoint                    = "us-east-1.linodeobjects.com"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
  }

  # Required providers definition.
  required_providers {
    linode = {
      source = "linode/linode"
    }

    akamai = {
      source = "akamai/akamai"
    }

    null = {
      source = "hashicorp/null"
    }

    random = {
      source = "hashicorp/random"
    }
  }
}