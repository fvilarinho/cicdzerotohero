# Definition of the DNS zone.
data "linode_domain" "default" {
  domain = var.settings.general.domain
}

# DNS record for the Gitea server.
resource "linode_domain_record" "serverHttp" {
  domain_id   = data.linode_domain.default.id
  name        = "${var.settings.server.hostname}.${var.settings.general.domain}"
  record_type = "CNAME"
  target      = akamai_edge_hostname.server.edge_hostname
  ttl_sec     = 30
  depends_on  = [
    data.linode_domain.default,
    akamai_edge_hostname.server,
    linode_instance.server,
    null_resource.applyServerStack
  ]
}

resource "linode_domain_record" "serverSsh" {
  domain_id   = data.linode_domain.default.id
  name        = "${var.settings.server.hostname}-ssh.${var.settings.general.domain}"
  record_type = "A"
  target      = linode_instance.server.ip_address
  ttl_sec     = 30
  depends_on  = [
    data.linode_domain.default,
    linode_instance.server,
    null_resource.applyServerStack
  ]
}

# DNS record for the Gitea actions runner.
resource "linode_domain_record" "runner" {
  domain_id   = data.linode_domain.default.id
  name        = "${var.settings.runner.hostname}.${var.settings.general.domain}"
  record_type = "A"
  target      = linode_instance.runner.ip_address
  ttl_sec     = 30
  depends_on  = [
    data.linode_domain.default,
    linode_instance.runner,
    null_resource.applyRunnerStack
  ]
}

# DNS record for the Sonarqube server.
resource "linode_domain_record" "codeQualityHttp" {
  domain_id   = data.linode_domain.default.id
  name        = "${var.settings.codeQuality.hostname}.${var.settings.general.domain}"
  record_type = "CNAME"
  target      = akamai_edge_hostname.codeQuality.edge_hostname
  ttl_sec     = 30
  depends_on  = [
    data.linode_domain.default,
    linode_instance.codeQuality,
    null_resource.applyCodeQualityStack
  ]
}

# Fetches all hostnames & edge hostnames of the CDN configuration.
data "akamai_property_hostnames" "server" {
  contract_id = var.settings.general.contract
  group_id    = var.settings.general.group
  property_id = akamai_property.server.id
  version     = akamai_property.server.latest_version
  depends_on  = [ akamai_property.server ]
}

data "akamai_property_hostnames" "codeQuality" {
  contract_id = var.settings.general.contract
  group_id    = var.settings.general.group
  property_id = akamai_property.codeQuality.id
  version     = akamai_property.codeQuality.latest_version
  depends_on  = [ akamai_property.codeQuality ]
}

# Validates the hostnames in the CDN configuration.
resource "linode_domain_record" "serverCertificateValidation" {
  domain_id   = data.linode_domain.default.id
  name        = data.akamai_property_hostnames.server.hostnames[0].cert_status[0].hostname
  record_type = "CNAME"
  target      = data.akamai_property_hostnames.server.hostnames[0].cert_status[0].target
  ttl_sec     = 30
  depends_on  = [
    data.akamai_property_hostnames.server,
    akamai_property.server
  ]
}

resource "linode_domain_record" "codeQualityCertificateValidation" {
  domain_id   = data.linode_domain.default.id
  name        = data.akamai_property_hostnames.codeQuality.hostnames[0].cert_status[0].hostname
  record_type = "CNAME"
  target      = data.akamai_property_hostnames.codeQuality.hostnames[0].cert_status[0].target
  ttl_sec     = 30
  depends_on  = [
    data.akamai_property_hostnames.codeQuality,
    akamai_property.codeQuality
  ]
}