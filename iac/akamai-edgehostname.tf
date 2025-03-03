# Definition of the Edge Hostnames that must be used in the Edge DNS entries of all hostnames that will pass through
# the CDN.
resource "akamai_edge_hostname" "server" {
  contract_id   = var.settings.general.contract
  group_id      = var.settings.general.group
  product_id    = var.settings.general.product
  edge_hostname = "${var.settings.server.hostname}.${var.settings.general.domain}.edgesuite.net"
  ip_behavior   = "IPV4"

  depends_on = [ linode_instance.server ]
}

resource "akamai_edge_hostname" "codeQuality" {
  contract_id   = var.settings.general.contract
  group_id      = var.settings.general.group
  product_id    = var.settings.general.product
  edge_hostname = "${var.settings.codeQuality.hostname}.${var.settings.general.domain}.edgesuite.net"
  ip_behavior   = "IPV4"

  depends_on = [ linode_instance.codeQuality ]
}