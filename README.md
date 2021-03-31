# terraform-azurerm-tfstate-backend

Terraform module that provisions an Azure Storage account to store the `terraform.tfstate` file, and a Key Vault to store the customer-managed encryption key.

## Instructions
* First, create a file called `terraform.tfvars` with the following contents:

```hcl
namespace = "myteam"
stage = "dev"
name = "tfstate"
attributes = ["tmp"]
```

* Log in to Azure and set the default subscription

```bash
az login
az account set --subscription my-subscription
```

* Create the Terraform state storage account.

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

Now we need to store this Terraform state in the bucket we just created.

* It will include the following instructions in the output. Follow the instructions by creating a file called `state.tf` with the Terraform content shown.

```
instructions = If you just ran this for the first time, you are using local Terraform state. Let's move the local Terraform state into the storage account that we just created.

Create a file called state.tf with the following contents:

terraform {
  backend "azurerm" {
    storage_account_name = "myteamdevtfstatetmp"
    container_name       = "myteam-dev-tfstate-tmp"
    key                  = "statebucket/terraform.tfstate"
    use_msi              = false
    subscription_id      = "<redacted>"
    tenant_id            = "<redacted>"
  }
}
```

* Now, run `terraform init -force-copy`. It will now ask you if you want to copy the existing state to the new backend. Type "yes":

```
> terraform init
Initializing modules...

Initializing the backend...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "azurerm" backend. No existing state was found in the newly
  configured "azurerm" backend. Do you want to copy this state to the new "azurerm"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value: yes
```

Terraform detects that you want to move your Terraform state to the Azure Storage backend, and it does so per `-auto-approve`. Now the state is stored in the Azure Storage account!


# Module Reference

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->

# References

* [Terraform documentation: AzureRM tfstate Backend](https://www.terraform.io/docs/language/settings/backends/azurerm.html)
* [cloudposse/terraform-aws-tfstate-backend](https://github.com/cloudposse/terraform-aws-tfstate-backend)
* [Azure Resource Name Rules for Storage](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules#microsoftstorage)
* [Azure Resource Name Rules for Key Vault](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules#microsoftkeyvault)
