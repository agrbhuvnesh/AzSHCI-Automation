# AzSHCI-Automation

Manage Diagnostic Level and Windows Server Subscription settings for Azure Stack HCI clusters using PowerShell and Azure CLI.

Fill up the values in enable-wss.parameters.json: 

1. cluster-names: array of the clusters to Manage Diagnostic Level and Windows Server Subscription
2. location: location where to create the DCR rule 
3. Workspace-id, workspace-name: details of the workspace created above


To run the ARM-template: 

New-AzResourceGroupDeployment -Name \<deployment-name> -ResourceGroupName \<resource-group> -TemplateFile .\enable-wss.json -TemplateParameterFile .\enable-wss.parameters.json
