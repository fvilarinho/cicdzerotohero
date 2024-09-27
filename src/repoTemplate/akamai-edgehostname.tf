# Definition of the Edge Hostname. This is the hostname that must be used in the Edge DNS entries
# of all hostnames that will pass through the CDN.
resource "akamai_edge_hostname" "default" {
  contract_id   = var.contractId
  group_id      = var.groupId
  product_id    = var.productId
  edge_hostname = "${var.propertyName}.${var.propertyDomain}.edgesuite.net"
  ip_behavior   = "IPV4"
}