$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""

 

$settingsConfig=@{
    "port"= "6516"
}

 

$connectivityConfig=@{
    "enabled"= "true"
}

 

 

## USING AZ CLI

 

az login --tenant $tenantId
az account set -s  $subscriptionId

 

$clusters = @(az stack-hci cluster list --resource-group $resourceGroup --query "[].name" -o tsv)

 

 

foreach ($currentCluster in $clusters) {
 
        "Enabling Connectivity for cluster $using:currentCluster"

 

        az stack-hci arc-setting update --resource-group $resourceGroup --cluster-name $currentCluster --name "default" --connectivity-properties "{enabled:true}"

	"Installing WAC extension for cluster $currentCluster"

	az stack-hci extension create --arc-setting-name "default" --cluster-name $currentCluster --extension-name "AdminCenter" --resource-group $resourceGroup --publisher "Microsoft.AdminCenter" --type "AdminCenter" --settings "{workspaceId:<workspaceid>}" 
    
}

 

 

## USING AZ POWERSHELL

 

Connect-AzAccount -Subscription $subscriptionId -Tenant $tenantId
$clusters = Get-AzResource -ResourceGroupName $resourceGroup -ResourceType "Microsoft.AzureStackHCI/clusters" | Select-Object -ExpandProperty Name

 

Foreach ($cluster in $Clusters) {
    Invoke-AzRestMethod -Method PATCH -SubscriptionId $subscriptionId -ResourceGroupName $resourceGroup -ResourceProviderName "Microsoft.AzureStackHCI" -ResourceType ("clusters/" + $cluster + "/arcSettings") -Name "default" -ApiVersion "2023-02-01" -Payload '{"properties": { "connectivityProperties": { "enabled": true } }}'

 

    New-AzStackHciExtension -ArcSettingName "default" -ClusterName $cluster -ResourceGroupName $resourceGroup -Name "AdminCenter" -ExtensionParameterPublisher "Microsoft.AdminCenter" -ExtensionParameterType "AdminCenter" -ExtensionParameterSetting $settingsConfig
    }