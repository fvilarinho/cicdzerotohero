# Required variables.
locals {
  certificateIssuanceScript              = abspath(pathexpand("../bin/certificateIssuance.sh"))
  certificateIssuanceCredentialsFilename = abspath(pathexpand("../etc/certificateIssuance.properties"))
  certificateFilename                    = abspath(pathexpand("../etc/ssl/certs/fullchain.pem"))
  certificateKeyFilename                 = abspath(pathexpand("../etc/ssl/private/privkey.pem"))
}

resource "linode_token" "certificateIssuance" {
  label  = "certificate-issuance"
  scopes = "domains:read_write"
}

# Creates the certificate issuance credentials.
resource "local_sensitive_file" "certificateIssuanceCredentials" {
  filename = local.certificateIssuanceCredentialsFilename
  content  = <<EOT
dns_linode_key = ${linode_token.certificateIssuance.token}
EOT
  depends_on = [ linode_token.certificateIssuance ]
}

# Issues the certificate using Certbot.
resource "null_resource" "certificateIssuance" {
  provisioner "local-exec" {
    # Required variables.
    environment = {
      CERTIFICATE_ISSUANCE_CREDENTIALS_FILENAME = local.certificateIssuanceCredentialsFilename
      CERTIFICATE_ISSUANCE_PROPAGATION_DELAY    = 600 // in seconds.
      DOMAIN                                    = var.settings.general.domain
      EMAIL                                     = var.settings.general.email
    }

    quiet   = true
    command = local.certificateIssuanceScript
  }

  depends_on = [ local_sensitive_file.certificateIssuanceCredentials ]
}

resource "local_sensitive_file" "certificate" {
  count      = (fileexists("/etc/letsencrypt/live/${var.settings.general.domain}/fullchain.pem") ? 1 : 0)
  filename   = local.certificateFilename
  content    = file("/etc/letsencrypt/live/${var.settings.general.domain}/fullchain.pem")
  depends_on = [ null_resource.certificateIssuance]
}

resource "local_sensitive_file" "certificateKey" {
  count      = (fileexists("/etc/letsencrypt/live/${var.settings.general.domain}/privkey.pem") ? 1 : 0)
  filename   = local.certificateKeyFilename
  content    = file("/etc/letsencrypt/live/${var.settings.general.domain}/privkey.pem")
  depends_on = [ null_resource.certificateIssuance]
}