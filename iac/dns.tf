# Definition of the DNS zone.
data "linode_domain" "default" {
  domain = var.settings.general.domain
}

# DNS record for the Gitea server.
resource "linode_domain_record" "server" {
  domain_id   = data.linode_domain.default.id
  name        = "gitea.${var.settings.general.domain}"
  record_type = "A"
  target      = linode_instance.server.ip_address
  ttl_sec     = 30
  depends_on  = [
    data.linode_domain.default,
    linode_instance.server
  ]
}

# DNS record for the Gitea actions runner.
resource "linode_domain_record" "runner" {
  domain_id   = data.linode_domain.default.id
  name        = "runner.${var.settings.general.domain}"
  record_type = "A"
  target      = linode_instance.runner.ip_address
  ttl_sec     = 30
  depends_on  = [
    data.linode_domain.default,
    linode_instance.runner
  ]
}