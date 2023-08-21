# AzSHCI-Automation
Run powershell script to install Azure Windows Azure Site Recovery Extension for Azure Stack HCI Clusters.
Pre-requisites:
	1. Create Workspace 'microsoft.operationalinsights/workspaces' manually before running script.
	2. Install-module az stack-cli using link https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows

## Update Variables in Scripts

To properly configure and run the scripts, you need to update certain variables within the provided scripts. Follow these steps to ensure accurate setup.### Step 2. update 4 variables in install_mma_extn
		$tenantID = ""
        $subscriptionId = ""
        $resourceGroup = ""
        $parametersFilePath = ""



### Step 1: Modify JSON Configuration

Update the JSON configuration block as shown below:

```json
{
    "properties": {
        "extensionParameters": {
            "type": "Windows",
            "publisher": "Microsoft.SiteRecovery.Dra",
            "autoUpgradeMinorVersion": false,
            "settings": {
                "SubscriptionId": "your-subscription-id",
                "Environment": "AzureCloud", 
                "ResourceGroup": "your-resource-group", 
                "ResourceName": "your-resource-name", 
                "Location": "East US", 
                "SiteId": "xxxxxxx-xxx-xx-xxxxxx-xxx", 
                "SiteName": "your-site-name", 
                "PrivateEndpointStateForSiteRecovery": "None"
            },
            "protectedSettings": {
               
            }
        }
    },
    "name": "AzureSiteRecovery"
}
