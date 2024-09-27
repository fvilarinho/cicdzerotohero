# Definition of the Terraform providers and state management.
terraform {
  # Stores the provisioning state in Akamai Cloud Computing Object Storage (Please change to use your own).
  backend "s3" {
    bucket                      = "fvilarin-devops"
    key                         = "akamai-as-code.tfstate"
    region                      = "us-east-1"
    endpoint                    = "us-east-1.linodeobjects.com"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
  }

  # Defines the providers used by the provisioning.
  required_providers {
    akamai = {
      source = "akamai/akamai"
    }

    linode = {
      source = "linode/linode"
    }
  }
}