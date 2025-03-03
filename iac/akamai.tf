# Defines the credentials for Akamai EdgeGrid.
provider "akamai" {
  config {
    account_key   = var.credentials.akamai.edgegrid.account
    host          = var.credentials.akamai.edgegrid.host
    access_token  = var.credentials.akamai.edgegrid.accessToken
    client_token  = var.credentials.akamai.edgegrid.clientToken
    client_secret = var.credentials.akamai.edgegrid.clientSecret
  }
}