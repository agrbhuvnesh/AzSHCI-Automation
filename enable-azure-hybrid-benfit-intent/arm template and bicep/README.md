# AzSHCI-Automation

Manage Azure Hybrid Benefit settings for Azure Stack HCI clusters using PowerShell and Azure CLI.

Pre-requisites:
	1. Create Workspace 'microsoft.operationalinsights/workspaces' manually before running script.
	2. Install Az Powershell https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell?view=azps-9.6.0

Fill up the values in enable-wss.parameters.json: 

1. cluster-names: array of the clusters to enable Azure Hybrid Benefit. 



To run the ARM-template: 

New-AzResourceGroupDeployment -Name \<deployment-name> -ResourceGroupName \<resource-group> -TemplateFile .\enable-AHB-intent.json -TemplateParameterFile .\enable-AHB-intent-parameters.json
