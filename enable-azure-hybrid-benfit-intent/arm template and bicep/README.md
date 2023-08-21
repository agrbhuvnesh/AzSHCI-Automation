# AzSHCI-Automation

Manage Azure Hybrid Benefit settings for Azure Stack HCI clusters using PowerShell and Azure CLI.

Fill up the values in enable-AHB-intent-parameters.json: 

1. cluster-names: array of the clusters to enable Azure Hybrid Benefit. 



To run the ARM-template: 

New-AzResourceGroupDeployment -Name \<deployment-name> -ResourceGroupName \<resource-group> -TemplateFile .\enable-AHB-intent.json -TemplateParameterFile .\enable-AHB-intent-parameters.json
