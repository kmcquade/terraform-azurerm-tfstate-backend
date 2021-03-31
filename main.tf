/*
# azurerm_resource_group: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
# azurerm_storage_account: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
# azurerm_storage_container: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container
*/

resource "azurerm_resource_group" "tfstate" {
  name     = var.resource_group_name == "" ? module.resource_group_label.id : var.resource_group_name
  location = var.location
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Storage
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_storage_account" "tfstate" {
  name                     = var.storage_account_name == "" ? module.storage_account_label.id : var.storage_account_name
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type

  # Explicit defaults
  access_tier  = "Hot"
  account_kind = "StorageV2"

  # This is necessary to access Key Vault
  identity {
    type = "SystemAssigned"
  }

  # Secure Defaults
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  allow_blob_public_access  = false

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = module.storage_container_label.id
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

# ---------------------------------------------------------------------------------------------------------------------
# Key Vault
# These are borrowed and adapted from the example here:
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_customer_managed_key
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_key_vault" "tfstate" {
  name                     = module.key_vault_label.id
  location                 = azurerm_resource_group.tfstate.location
  resource_group_name      = azurerm_resource_group.tfstate.name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = var.key_vault_sku_name
  purge_protection_enabled = true
  soft_delete_enabled      = true
}

resource "azurerm_key_vault_access_policy" "storage" {
  key_vault_id = azurerm_key_vault.tfstate.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_storage_account.tfstate.identity.0.principal_id

  key_permissions    = ["get", "create", "list", "restore", "recover", "unwrapkey", "wrapkey", "purge", "encrypt", "decrypt", "sign", "verify"]
  secret_permissions = ["get"]
}

resource "azurerm_key_vault_access_policy" "client" {
  key_vault_id = azurerm_key_vault.tfstate.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions    = ["get", "create", "delete", "list", "restore", "recover", "unwrapkey", "wrapkey", "purge", "encrypt", "decrypt", "sign", "verify"]
  secret_permissions = ["get"]
}

resource "azurerm_key_vault_key" "tfstate" {
  name         = module.key_vault_label.id
  key_vault_id = azurerm_key_vault.tfstate.id
  key_type     = var.key_vault_key_type # RSA or RSA-HSM
  key_size     = 2048
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]

  depends_on = [
    azurerm_key_vault_access_policy.client,
    azurerm_key_vault_access_policy.storage,
  ]
  # TODO: Add tags
}

resource "azurerm_storage_account_customer_managed_key" "tfstate" {
  storage_account_id = azurerm_storage_account.tfstate.id
  key_vault_id       = azurerm_key_vault.tfstate.id
  key_name           = azurerm_key_vault_key.tfstate.name
  key_version        = null # null enables automatic key rotation
}
