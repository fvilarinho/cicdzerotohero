# Definition of the initial password for the compute instance.
resource "random_string" "computeInitialPassword" {
  length = 15
}

# Definition of the compute instance.
resource "linode_instance" "cicdzerotohero" {
  label            = var.compute.id
  tags             = var.compute.tags
  region           = var.compute.region
  type             = var.compute.type
  image            = var.compute.image
  root_pass        = random_string.computeInitialPassword.result
  stackscript_id   = linode_stackscript.cicdzerotohero.id
  stackscript_data = {
    HOSTNAME               = var.compute.id
    EDGEGRID_ACCOUNT_KEY   = var.edgeGridAccountKey
    EDGEGRID_HOST          = var.edgeGridHost
    EDGEGRID_ACCESS_TOKEN  = var.edgeGridAccessToken
    EDGEGRID_CLIENT_TOKEN  = var.edgeGridClientToken
    EDGEGRID_CLIENT_SECRET = var.edgeGridClientSecret
    ACC_TOKEN              = var.accToken
  }

  depends_on = [
    random_string.computeInitialPassword,
    linode_stackscript.cicdzerotohero
  ]
}

# Displays the initial password for the compute instance.
resource "null_resource" "showComputeInitialPassword" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    quiet   = true
    command = <<EOT
#!/bin/bash

echo
echo "The compute instance initial password is: ${random_string.computeInitialPassword.result}"
echo
echo "For remote access, just type ssh root@${linode_instance.cicdzerotohero.ip_address} in your terminal!"
echo
EOT
  }

  depends_on = [
    linode_instance.cicdzerotohero,
    random_string.computeInitialPassword
  ]
}