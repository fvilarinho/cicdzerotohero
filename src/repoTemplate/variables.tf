variable "linodeToken" {
  type = string
}

variable "edgeGridAccountKey" {
  type = string
}

variable "edgeGridHost" {
  type = string
}

variable "edgeGridAccessToken" {
  type = string
}

variable "edgeGridClientToken" {
  type = string
}

variable "edgeGridClientSecret" {
  type = string
}

variable "contractId" {
  type = string
}

variable "groupId" {
  type = string
}

variable "productId" {
  type    = string
  default = "prd_Fresca"
}

variable "propertyName" {
  type    = string
  default = "akamai-as-code"
}

variable "propertyDomain" {
  type    = string
  default = "vila.app.br"
}

variable "notificationEmail" {
  type = string
}