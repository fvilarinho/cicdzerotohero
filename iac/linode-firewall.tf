# Fetches the local IP.
data "http" "myIp" {
  url    = "https://ipinfo.io"
  method = "GET"
}

# Firewall rules to protect Gitea server.
resource "linode_firewall" "server" {
  label           = "${var.settings.server.name}-fw"
  tags            = var.settings.server.tags
  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  inbound {
    action   = "ACCEPT"
    label    = "allow-akamai-ips"
    protocol = "TCP"
    ports    = "22,443"
    ipv4 = [
      "139.144.212.168/31",
      "172.232.23.164/31",
      "172.236.119.4/30",
      "172.234.160.4/30",
      "172.236.94.4/30"
    ]
    ipv6 = [
      "2600:3c06::f03c:94ff:febe:162f/128",
      "2600:3c06::f03c:94ff:febe:16ff/128",
      "2600:3c06::f03c:94ff:febe:16c5/128",
      "2600:3c07::f03c:94ff:febe:16e6/128",
      "2600:3c07::f03c:94ff:febe:168c/128",
      "2600:3c07::f03c:94ff:febe:16de/128",
      "2600:3c08::f03c:94ff:febe:16e9/128",
      "2600:3c08::f03c:94ff:febe:1655/128",
      "2600:3c08::f03c:94ff:febe:16fd/128"
    ]
  }

  inbound {
    action   = "ACCEPT"
    label    = "allow-external-ips"
    protocol = "TCP"
    ports    = "22,2222,80,443"
    ipv4     = concat(var.settings.server.allowedIps.ipv4,
                      [
                        "${linode_instance.runner.ip_address}/32",
                        "${linode_instance.runner.private_ip_address}/32",
                        "${jsondecode(data.http.myIp.response_body).ip}/32"
                      ]
               )
    ipv6     = concat(var.settings.server.allowedIps.ipv6, [ "::1/128" ])
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
  label           = "${var.settings.runner.name}-fw"
  tags            = var.settings.runner.tags
  inbound_policy  = "DROP"
  outbound_policy = "ACCEPT"

  inbound {
    action   = "ACCEPT"
    label    = "allow-akamai-ips"
    protocol = "TCP"
    ports    = "22,443"
    ipv4 = [
      "139.144.212.168/31",
      "172.232.23.164/31",
      "172.236.119.4/30",
      "172.234.160.4/30",
      "172.236.94.4/30"
    ]
    ipv6 = [
      "2600:3c06::f03c:94ff:febe:162f/128",
      "2600:3c06::f03c:94ff:febe:16ff/128",
      "2600:3c06::f03c:94ff:febe:16c5/128",
      "2600:3c07::f03c:94ff:febe:16e6/128",
      "2600:3c07::f03c:94ff:febe:168c/128",
      "2600:3c07::f03c:94ff:febe:16de/128",
      "2600:3c08::f03c:94ff:febe:16e9/128",
      "2600:3c08::f03c:94ff:febe:1655/128",
      "2600:3c08::f03c:94ff:febe:16fd/128"
    ]
  }

  inbound {
    action   = "ACCEPT"
    label    = "allow-external-ips"
    protocol = "TCP"
    ports    = "22,2222,80,443"
    ipv4     = concat(var.settings.server.allowedIps.ipv4,
                      [
                        "${linode_instance.server.ip_address}/32",
                        "${linode_instance.server.private_ip_address}/32",
                        "${jsondecode(data.http.myIp.response_body).ip}/32"
                      ]
               )
    ipv6     = concat(var.settings.server.allowedIps.ipv6, [ "::1/128" ])
  }

  inbound {
    action   = "ACCEPT"
    label    = "allow-icmp"
    protocol = "ICMP"
    ipv4     = [ "0.0.0.0/0" ]
  }

  linodes = [ linode_instance.runner.id ]

  depends_on = [
    linode_instance.server,
    linode_instance.runner,
    data.http.myIp
  ]
}