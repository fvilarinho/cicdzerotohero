# Definition of the Stack Script.
resource "linode_stackscript" "cicdzerotohero" {
  label       = var.stackscript.id
  description = var.stackscript.description
  is_public   = var.stackscript.public
  images      = var.stackscript.images
  script      = chomp(file(var.stackscript.filename))
}