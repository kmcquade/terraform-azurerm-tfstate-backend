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