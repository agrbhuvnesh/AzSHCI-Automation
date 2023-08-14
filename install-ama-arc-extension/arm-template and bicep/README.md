# AzSHCI-Automation
ARM template to install Azure Windows Monitoring Agent Arc Extension for Azure Stack HCI Clusters.
	1. Creates DCR rule 
	2. Installs AMA on clusters 
	3. associates the DCR rule with the extension


Pre-requisites:
	1. Create Workspace 'microsoft.operationalinsights/workspaces' manually before running script.
	2. Install Az Powershell https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell?view=azps-9.6.0

Fill up the values in ama-parameters.json: 

1. cluster-names: array of the clusters to install AMA on



To run the ARM-template: 

New-AzResourceGroupDeployment -Name \<deployment-name> -ResourceGroupName \<resource-group> -TemplateFile .\install-ama.json -TemplateParameterFile .\ama-parameters.json

deployment-name : any unique name for your deployment 
resource-group: resource group to target which contains the resources

To run the bicep: 

New-AzResourceGroupDeployment -Name \<deployment-name> -ResourceGroupName \<resource-group> -TemplateFile .\install-ama.bicep -TemplateParameterFile .\ama-parameters.json

deployment-name : any unique name for your deployment 
resource-group: resource group to target which contains the resources
