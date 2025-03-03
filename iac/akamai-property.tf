# Definition of the property rules (CDN configuration).
data "akamai_property_rules_template" "server" {
  template_file = abspath(pathexpand("../etc/gitea-server/akamai-property/main.json"))

  # Definition of the Origin Hostname variable.
  variables {
    name  = "origin"
    type  = "string"
    value = linode_instance.server.ip_address
  }

  # Definition of the CP Code variable.
  variables {
    name  = "cpCode"
    type  = "number"
    value = replace(akamai_cp_code.server.id, "cpc_", "")
  }

  depends_on = [
    akamai_cp_code.server,
    linode_instance.server
  ]
}

data "akamai_property_rules_template" "codeQuality" {
  template_file = abspath(pathexpand("../etc/sonarqube-server/akamai-property/main.json"))

  # Definition of the Origin Hostname variable.
  variables {
    name  = "origin"
    type  = "string"
    value = linode_instance.codeQuality.ip_address
  }

  # Definition of the CP Code variable.
  variables {
    name  = "cpCode"
    type  = "number"
    value = replace(akamai_cp_code.codeQuality.id, "cpc_", "")
  }

  depends_on = [
    akamai_cp_code.codeQuality,
    linode_instance.codeQuality
  ]
}

# Definition of the property (CDN configuration) of the Gitea server.
resource "akamai_property" "server" {
  contract_id = var.settings.general.contract
  group_id    = var.settings.general.group
  product_id  = var.settings.general.product
  name        = var.settings.server.name
  rules       = data.akamai_property_rules_template.server.json

  # Definition of all hostnames of the property.
  hostnames {
    cname_from             = "${var.settings.server.hostname}.${var.settings.general.domain}"
    cname_to               = akamai_edge_hostname.server.edge_hostname
    cert_provisioning_type = "DEFAULT"
  }

  depends_on = [
    data.akamai_property_rules_template.server,
    akamai_edge_hostname.server
  ]
}

resource "akamai_property" "codeQuality" {
  contract_id = var.settings.general.contract
  group_id    = var.settings.general.group
  product_id  = var.settings.general.product
  name        = var.settings.codeQuality.name
  rules       = data.akamai_property_rules_template.codeQuality.json

  # Definition of all hostnames of the property.
  hostnames {
    cname_from             = "${var.settings.codeQuality.hostname}.${var.settings.general.domain}"
    cname_to               = akamai_edge_hostname.codeQuality.edge_hostname
    cert_provisioning_type = "DEFAULT"
  }

  depends_on = [
    data.akamai_property_rules_template.codeQuality,
    akamai_edge_hostname.codeQuality
  ]
}

# Activates the property (CDN configuration) in staging network.
resource "akamai_property_activation" "serverStaging" {
  property_id                    = akamai_property.server.id
  version                        = akamai_property.server.latest_version
  contact                        = [ var.settings.general.email ]
  network                        = "STAGING"
  auto_acknowledge_rule_warnings = true
  depends_on                     = [ akamai_property.server ]
}

resource "akamai_property_activation" "codeQualityStaging" {
  property_id                    = akamai_property.codeQuality.id
  version                        = akamai_property.codeQuality.latest_version
  contact                        = [ var.settings.general.email ]
  network                        = "STAGING"
  auto_acknowledge_rule_warnings = true
  depends_on                     = [ akamai_property.codeQuality ]
}

# Activates the property (CDN configuration) in production network.
resource "akamai_property_activation" "serverProduction" {
  property_id                    = akamai_property.server.id
  version                        = akamai_property.server.latest_version
  contact                        = [ var.settings.general.email ]
  network                        = "PRODUCTION"
  auto_acknowledge_rule_warnings = true

  compliance_record {
    noncompliance_reason_no_production_traffic {
    }
  }

  depends_on = [ akamai_property_activation.serverStaging ]
}

resource "akamai_property_activation" "codeQualityProduction" {
  property_id                    = akamai_property.codeQuality.id
  version                        = akamai_property.codeQuality.latest_version
  contact                        = [ var.settings.general.email ]
  network                        = "PRODUCTION"
  auto_acknowledge_rule_warnings = true

  compliance_record {
    noncompliance_reason_no_production_traffic {
    }
  }

  depends_on = [ akamai_property_activation.codeQualityStaging ]
}