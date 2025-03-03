# Definition of the Edge Hostname. This is the hostname that must be used in the Edge DNS entries
# of all hostnames that will pass through the CDN.
resource "akamai_edge_hostname" "default" {
  contract_id   = var.settings.akamai.property.contract
  group_id      = var.settings.akamai.property.group
  product_id    = var.settings.akamai.property.product
  edge_hostname = "${var.settings.akamai.property.name}.edgesuite.net"
  ip_behavior   = "IPV4"
}