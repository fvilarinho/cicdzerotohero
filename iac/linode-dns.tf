data "linode_domain" "default" {
  domain = var.settings.general.domain
}

resource "linode_domain_record" "default" {
  domain_id   = data.linode_domain.default.id
  name        = "gitea.${var.settings.general.domain}"
  record_type = "A"
  target      = linode_instance.default.ip_address
  ttl_sec     = 30
  depends_on  = [
    data.linode_domain.default,
    linode_instance.default
  ]
}