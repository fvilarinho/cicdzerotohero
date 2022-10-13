variable "linode_token" {}

variable "git_public_key" {
  default = "~/.ssh/id_rsa.pub"
}
variable "git_private_key" {
  default = "~/.ssh/id_rsa"
}
variable "git_label" {
  default = "gogs"
}
variable "git_type" {
  default = "g6-standard-1"
}
variable "git_image" {
  default = "linode/debian11"
}
variable "git_region" {
  default = "us-east"
}

variable "jenkins_public_key" {
  default = "~/.ssh/id_rsa.pub"
}
variable "jenkins_private_key" {
  default = "~/.ssh/id_rsa"
}
variable "jenkins_label" {
  default = "jenkins"
}
variable "jenkins_type" {
  default = "g6-standard-2"
}
variable "jenkins_image" {
  default = "linode/debian11"
}
variable "jenkins_region" {
  default = "us-east"
}