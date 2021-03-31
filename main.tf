/*
# azurerm_resource_group: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
# azurerm_storage_account: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
*/
locals {
  resource_group_name  = var.resource_group_name == "" ? module.resource_group_label.id : var.resource_group_name
  storage_account_name = var.storage_account_name == "" ? module.storage_account_label.id : var.storage_account_name

  # Format names

}
resource "azurerm_resource_group" "tfstate" {
  name     = var.resource_group_name == "" ? module.resource_group_label.id : var.resource_group_name
  location = var.location
}

#checkov:skip=CKV_AZURE_35:Not running from a VNet
resource "azurerm_storage_account" "tfstate" {
  name                     = var.storage_account_name == "" ? module.storage_account_label.id : var.storage_account_name
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type

  # Explicit defaults
  access_tier  = "Hot"
  account_kind = "StorageV2"


  # Secure Defaults
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  allow_blob_public_access  = false

  tags = {
    environment = "staging"
  }
}