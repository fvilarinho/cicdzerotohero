data "linode_domain" "default" {
  domain = var.propertyDomain
}

resource "linode_domain_record" "default" {
  domain_id   = data.linode_domain.default.id
  name        = "${var.propertyName}.${var.propertyDomain}"
  record_type = "CNAME"
  target      = "${var.propertyName}.${var.propertyDomain}.edgesuite-staging.net"
  ttl_sec     = 30
  depends_on  = [
    akamai_property_activation.staging
  ]
}

data "akamai_property_hostnames" "default" {
  contract_id = var.contractId
  group_id    = var.groupId
  property_id = akamai_property.default.id
  version     = akamai_property.default.latest_version
  depends_on  = [ akamai_property.default ]
}

resource "linode_domain_record" "certificateValidation" {
  domain_id   = data.linode_domain.default.id
  name        = data.akamai_property_hostnames.default.hostnames[0].cert_status[0].hostname
  record_type = "CNAME"
  target      = data.akamai_property_hostnames.default.hostnames[0].cert_status[0].target
  ttl_sec     = 30
  depends_on  = [ data.akamai_property_hostnames.default ]
}