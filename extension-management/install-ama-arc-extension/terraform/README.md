# AzSHCI-Automation

Terraform code to install Azure Windows Monitoring Agent (AMA) Arc Extension for Azure Stack HCI Clusters.
	1. Creates DCR rule 
	2. Installs AMA on clusters 
	3. Associates the DCR rule with the extension on the clusters

Pre-requisites:
	1. Create Workspace 'microsoft.operationalinsights/workspaces' manually before running script.
	2. Install Az Powershell https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell?view=azps-9.6.0

Configure the variable values in variables.tfvars:

1. clusterResourceIds: array of the cluster resource IDs to install AMA on .
2. location: location where to create the DCR rule.
3. resourceGroupName: Name of the resource group where the log analytics workspace exists.
4. workspaceId, workspaceName: details of the workspace created above
5. azStackHCIApiVersion: Azure Stack HCI Cluster api version to be used with azapi_resource terraform resource
6. azStackHCIDataCollectionRuleAssociationApiVersion: Azure Stack HCI Data Collection Rule Association api version to be used with azapi_resource terraform resource

To run the Terraform module use the following commands from the Terraform directory:

```
# Login to Azure

terraform init
terraform plan -var-file="variables.tfvars"
terraform apply -var-file="variables.tfvars"
```