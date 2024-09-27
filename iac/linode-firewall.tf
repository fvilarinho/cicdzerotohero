# Fetches the local IP.
data "http" "myIp" {
  url    = "https://ipinfo.io"
  method = "GET"
}

# Firewall rules to protect Gitea server.
resource "linode_firewall" "server" {
  label           = "${var.settings.server.label}-firewall"
  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  inbound {
    action   = "ACCEPT"
    label    = "allowed-ips"
    protocol = "TCP"
    ipv4     = [
      "${jsondecode(data.http.myIp.response_body).ip}/32",
      "${linode_instance.runner.ip_address}/32"
    ]
  }

  inbound {
    action   = "ACCEPT"
    label    = "allow-icmp"
    protocol = "ICMP"
    ipv4     = [ "0.0.0.0/0" ]
  }

  linodes = [ linode_instance.server.id]

  depends_on = [
    linode_instance.server,
    linode_instance.runner,
    data.http.myIp
  ]
}

# Firewall rules to protect Gitea actions runner.
resource "linode_firewall" "runner" {
  label           = "${var.settings.runner.label}-firewall"
  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  inbound {
    action   = "ACCEPT"
    label    = "allowed-ips"
    protocol = "TCP"
    ipv4     = [
      "${jsondecode(data.http.myIp.response_body).ip}/32",
      "${linode_instance.server.ip_address}/32"
    ]
  }

  inbound {
    action   = "ACCEPT"
    label    = "allow-icmp"
    protocol = "ICMP"
    ipv4     = [ "0.0.0.0/0" ]
  }

  linodes = [ linode_instance.runner.id]

  depends_on = [
    linode_instance.server,
    linode_instance.runner,
    data.http.myIp
  ]
}