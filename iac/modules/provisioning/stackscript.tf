# Definition of the Stack Script.
resource "linode_stackscript" "cicdzerotohero" {
  label       = var.stackscript.id
  description = var.stackscript.description
  script      = chomp(file(var.stackscript.filename))
  images      = var.stackscript.images
}