# AzSHCI-Automation
ARM template to install Azure Site Recovery Arc Extension for Azure Stack HCI Clusters.
	1. Installs ASR on clusters 


Pre-requisites:
	1. Check pre-reqs from the intsall-asr readme.
	2. Create a Site Recovery Vault and Site to be used.
	3. Install Az Powershell https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell?view=azps-9.6.0

Fill up the values in ama-parameters.json: 

1. cluster-names: array of the clusters to install AMA on 
2. recoverySiteId: Site Id for the recovery vault 
3. recoverySiteName: name of the site id for the recovery vault
4. recoveryServicesVaultName: Vault name for recovery services 
5. recoveryServicesVaultResourceGroup: resource group where the recovery vault is present
6. recoveryServicesVaultLocation: location of the recovery vault 


To run the ARM-template: 

New-AzResourceGroupDeployment -Name <deployment-name> -ResourceGroupName <resource-group> -TemplateFile .\install-asr.json -TemplateParameterFile .\asr-parameters.json

deployment-name : any unique name for your deployment 
resource-group: resource group to target which contains the resources

To run the bicep: 

New-AzResourceGroupDeployment -Name <deployment-name> -ResourceGroupName <resource-group> -TemplateFile .\install-asr.bicep -TemplateParameterFile .\asr-parameters.json

deployment-name : any unique name for your deployment 
resource-group: resource group to target which contains the resources
