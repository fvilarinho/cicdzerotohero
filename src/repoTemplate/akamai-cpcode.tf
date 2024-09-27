# Definition of the CP Code used for reporting and billing.
resource "akamai_cp_code" "default" {
  contract_id = var.contractId
  group_id    = var.groupId
  product_id  = var.productId
  name        = var.propertyName
}