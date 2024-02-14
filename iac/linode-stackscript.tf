# Definition of the Stack Script.
resource "linode_stackscript" "default" {
  label       = local.settings.stackScript.label
  description = local.settings.stackScript.description
  is_public   = local.settings.stackScript.public
  images      = local.settings.stackScript.images
  script      = chomp(file(local.settings.stackScript.filename))
}