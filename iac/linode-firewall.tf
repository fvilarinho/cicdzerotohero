data "http" "myIp" {
  url    = "https://ipinfo.io"
  method = "GET"
}

resource "linode_firewall" "default" {
  label           = "${var.settings.server.label}-firewall"
  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  inbound {
    action   = "ACCEPT"
    label    = "allowed-ips"
    protocol = "TCP"
    ipv4     = [ "${jsondecode(data.http.myIp.response_body).ip}/32" ]
  }

  inbound {
    action   = "ACCEPT"
    label    = "allow-icmp"
    protocol = "ICMP"
    ipv4     = [ "0.0.0.0/0" ]
  }

  linodes = [ linode_instance.default.id]

  depends_on = [
    linode_instance.default,
    data.http.myIp
  ]
}