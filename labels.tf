# Resource Group
module "resource_group_label" {
  source       = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=0.4.0"
  namespace    = var.namespace
  stage        = var.stage
  name         = var.name
  attributes   = var.attributes
  delimiter    = "-"
  convert_case = true
  tags         = var.default_tags
  enabled      = var.resource_group_name == "" ? true : false
}

# Storage Account
# Must be between 3-24 characters, lowercase letters and numbers only
module "storage_account_label" {
  source       = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=0.4.0"
  namespace    = var.namespace
  stage        = var.stage
  name         = var.name
  attributes   = var.attributes
  delimiter    = ""
  convert_case = true
  tags         = var.default_tags
  enabled      = var.storage_account_name == "" ? true : false
}

# Storage Container Label
# 3-63 characters
# Lowercase letters, numbers, and hyphens.
# Start with lowercase letter or number. Can't use consecutive hyphens.
module "storage_container_label" {
  source       = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=0.4.0"
  namespace    = var.namespace
  stage        = var.stage
  name         = var.name
  attributes   = var.attributes
  delimiter    = "-"
  convert_case = true
  tags         = var.default_tags
  enabled      = var.storage_account_name == "" ? true : false
}

# Key Vault
# 3-24 characters
# Alphanumerics and hyphens.
# Start with letter. End with letter or digit. Can't contain consecutive hyphens.
# https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules#microsoftkeyvault
module "key_vault_label" {
  source       = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=0.4.0"
  namespace    = var.namespace
  stage        = var.stage
  name         = var.name
  attributes   = var.attributes
  delimiter    = "-"
  convert_case = true
  tags         = var.default_tags
  enabled      = var.storage_account_name == "" ? true : false
}
