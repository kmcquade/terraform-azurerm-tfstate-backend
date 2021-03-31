SHELL:=/bin/bash

# ---------------------------------------------------------------------------------------------------------------------
# Miscellaneous
# ---------------------------------------------------------------------------------------------------------------------
# Auto generate docs
docs:
	@terraform-docs markdown table --sort-by-required . > README.md

# ---------------------------------------------------------------------------------------------------------------------
# Security scans
# ---------------------------------------------------------------------------------------------------------------------
# Security scans with tfsec
tfsec:
	@tfsec .

# Security scans with Checkov
checkov:
	@checkov -d ./

security: tfsec checkov

# ---------------------------------------------------------------------------------------------------------------------
# Format checks
# ---------------------------------------------------------------------------------------------------------------------
# Auto format
fmt:
	@terraform fmt .

# Lint
lint:
	@terraform fmt -diff=true -check .

# ---------------------------------------------------------------------------------------------------------------------
# Terraform init/plan/apply
# ---------------------------------------------------------------------------------------------------------------------
init:
	@terraform init

plan: init
	@terraform plan

apply: plan
	@terraform apply -auto-approve