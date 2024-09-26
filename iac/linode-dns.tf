data "linode_domain" "default" {
  domain = var.settings.general.domain
}

resource "linode_domain_record" "default" {
  domain_id   = data.linode_domain.default.id
  record_type = "A"
  target      = linode_instance.default.ip_address
  depends_on  = [
    data.linode_domain.default,
    linode_instance.default
  ]
}