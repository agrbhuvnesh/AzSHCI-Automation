# AzSHCI-Automation

Terraform code to to install Windows Admin Center Arc Extension for Azure Stack HCI Clusters.
	1. Install WAC extension on the clusters 

Pre-requisites:
	1. Install Az Powershell https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell?view=azps-9.6.0
	2. [Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

Configure the variable values in variables.tfvars:

1. clusterResourceIds: array of the cluster resource IDs to install extension on .
2. azStackHCIApiVersion: Azure Stack HCI Cluster api version to be used with azapi_resource terraform resource
3. port: port to use for WAC

To run the Terraform module use the following commands from the Terraform directory:

```
# Login to Azure
terraform init
terraform plan -var-file="variables.tfvars"
terraform apply -var-file="variables.tfvars"
```