$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""
$settingsConfig = "{'port':'6516'}"
$arcsettingname = "default"
$extensionname = "AdminCenter"
$publisherName = "Microsoft.AdminCenter"
$extensionType = "AdminCenter"
$connectivityProps = "{enabled:true}"
$RPName = "Microsoft.AzureStackHCI"
$ApiVersion = "2023-02-01"

# Using Command Line Interface (CLI)

# Login using Azure Active Directory
az login --tenant $tenantId
az account set -s  $subscriptionId

# Get all clusters in the resource group
"Getting all clusters in the resource group"
$clusters = @(az stack-hci cluster list --resource-group $resourceGroup --query "[].name" -o tsv)

# Install WAC extension for each cluster
"Installing WAC extension for each cluster"
foreach ($currentCluster in $clusters) {
    "Enabling Connectivity for cluster $currentCluster"
    az stack-hci arc-setting update `
        --resource-group $resourceGroup `
        --cluster-name $currentCluster `
        --name $arcsettingname `
        --connectivity-properties $connectivityProps

    "Installing WAC extension for cluster $currentCluster"
    az stack-hci extension create `
        --arc-setting-name $arcsettingname  `
        --cluster-name $currentCluster `
        --extension-name $extensionname `
        --resource-group $resourceGroup `
        --publisher $publisherName `
        --type $extensionType `
        --settings $settingsConfig
}

# Using Powershell

# Login using Azure Active Directory
Connect-AzAccount -Subscription $subscriptionId -Tenant $tenantId

# Get the list of clusters
"Getting the list of all clusters"
$resourceType = "Microsoft.AzureStackHCI/clusters" 
$clusters = Get-AzResource -ResourceGroupName $resourceGroup -ResourceType $resourceType | Select-Object -ExpandProperty Name

# Install WAC extension for each cluster
"Installing WAC extension for each cluster"
$settingsConfig = @{"port" = 6516 }
Foreach ($cluster in $Clusters) {
    Write-Host("Enabling Connectivity for cluster $cluster")
    # Update arc setting is not supproted yet through Az stack hci powershell 
    Invoke-AzRestMethod `
        -Method PATCH `
        -SubscriptionId $subscriptionId `
        -ResourceGroupName $resourceGroup `
        -ResourceProviderName $RPName`
        -ResourceType ("clusters/" + $cluster + "/arcSettings") `
        -Name $arcsettingname `
        -ApiVersion $ApiVersion `
        -Payload (@{"properties" = @{ "connectivityProperties" = @{ "enabled" = $true } } } | ConvertTo-Json -Depth 5)

 
    Write-Host("Installing WAC extension for cluster $cluster")
    New-AzStackHciExtension `
        -ArcSettingName $arcsettingname  `
        -ClusterName $cluster `
        -ResourceGroupName $resourceGroup `
        -Name $extensionname `
        -ExtensionParameterPublisher $publisherName `
        -ExtensionParameterType $extensionType `
        -ExtensionParameterSetting $settingsConfig
        -NoWait 
}
