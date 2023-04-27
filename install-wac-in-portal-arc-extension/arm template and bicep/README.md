# AzSHCI-Automation
ARM template to install Windows Admin Center Arc Extension for Azure Stack HCI Clusters.
	1. Install WAC extension on the clusters 


Pre-requisites:
	1. Install Az Powershell https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell?view=azps-9.6.0

Fill up the values in wac-parameters.json: 

1. cluster-names: array of the clusters to install WAC on 
2. port: port to use for WAC 


To run the ARM-template: 

New-AzResourceGroupDeployment -Name <deployment-name> -ResourceGroupName <resource-group> -TemplateFile .\wac_template.json -TemplateParameterFile .\wac-parameters.json

deployment-name : any unique name for your deployment 
resource-group: resource group to target which contains the resources

To run the bicep: 

New-AzResourceGroupDeployment -Name <deployment-name> -ResourceGroupName <resource-group> -TemplateFile .\wac_template.bicep -TemplateParameterFile .\wac-parameters.json

deployment-name : any unique name for your deployment 
resource-group: resource group to target which contains the resources
