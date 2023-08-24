# AzSHCI-Automation
ARM template to install Azure Windows Monitoring Agent Arc Extension for Azure Stack HCI Clusters.
	1. Creates DCR rule 
	2. Installs MMA on clusters 
	3. associates the DCR rule with the extension


Pre-requisites:
	1. Create Workspace 'microsoft.operationalinsights/workspaces' (Log Analytics workspace) manually before running script.
	2. Install Az Powershell https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell?view=azps-9.6.0

Fill up the values in mma-parameters.json: 

1. cluster-names: array of the clusters to install MMA on 
2. location: location where to create the DCR rule 
3. Workspace-id, workspace-name: details of the workspace created above


To run the ARM-template: 

New-AzResourceGroupDeployment -Name <deployment-name> -ResourceGroupName <resource-group> -TemplateFile .\mma_template.json -TemplateParameterFile .\mma_parameters.json

deployment-name : any unique name for your deployment 
resource-group: resource group to target which contains the resources

To run the bicep: 

New-AzResourceGroupDeployment -Name <deployment-name> -ResourceGroupName <resource-group> -TemplateFile .\mma_template.bicep -TemplateParameterFile .\mma_parameters.json

deployment-name : any unique name for your deployment 
resource-group: resource group to target which contains the resources
