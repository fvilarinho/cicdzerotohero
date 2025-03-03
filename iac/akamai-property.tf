# Definition of the property rules (CDN configuration).
data "akamai_property_rules_template" "default" {
  template_file = abspath(pathexpand("../etc/akamai-property/main.json"))

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
    value = replace(akamai_cp_code.default.id, "cpc_", "")
  }

  depends_on = [
    akamai_cp_code.default,
    linode_instance.server
  ]
}

# Definition of the property (CDN configuration).
resource "akamai_property" "default" {
  contract_id = var.settings.akamai.property.contract
  group_id    = var.settings.akamai.property.group
  product_id  = var.settings.akamai.property.product
  name        = var.settings.akamai.property.name
  rules       = data.akamai_property_rules_template.default.json

  # Definition of all hostnames of the property.
  hostnames {
    cname_from             = "gitea.${var.settings.general.domain}"
    cname_to               = akamai_edge_hostname.default.edge_hostname
    cert_provisioning_type = "DEFAULT"
  }

  depends_on = [
    data.akamai_property_rules_template.default,
    akamai_edge_hostname.default
  ]
}

# Activates the property (CDN configuration) in staging network.
resource "akamai_property_activation" "staging" {
  property_id                    = akamai_property.default.id
  version                        = akamai_property.default.latest_version
  contact                        = [ var.settings.general.email ]
  network                        = "STAGING"
  auto_acknowledge_rule_warnings = true
  depends_on                     = [ akamai_property.default ]
}

# Activates the property (CDN configuration) in production network.
resource "akamai_property_activation" "production" {
  property_id                    = akamai_property.default.id
  version                        = akamai_property.default.latest_version
  contact                        = [ var.settings.general.email ]
  network                        = "PRODUCTION"
  auto_acknowledge_rule_warnings = true

  compliance_record {
    noncompliance_reason_no_production_traffic {
    }
  }

  depends_on = [ akamai_property_activation.staging ]
}