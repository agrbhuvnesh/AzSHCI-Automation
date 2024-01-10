
$variables = Get-Content "./variables.json" | ConvertFrom-Json

$subscriptionId = $variables.subscriptionId
$resourceGroup = $variables.resourceGroup
$tenantId = $variables.tenantId
$settingsConfig = "{'port':'6516'}"
$extensionname = "AdminCenter"
$publisherName = "Microsoft.AdminCenter"
$extensionType = "AdminCenter"
$connectivityProps = "{enabled:true}"
$RPName = "Microsoft.AzureStackHCI"
$ApiVersion = "2023-02-01"

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
        -Name "default" `
        -ApiVersion $ApiVersion `
        -Payload (@{"properties" = @{ "connectivityProperties" = @{ "enabled" = $true } } } | ConvertTo-Json -Depth 5)

 
    Write-Host("Installing WAC extension for cluster $cluster")
    New-AzStackHciExtension `
        -ArcSettingName "default"  `
        -ClusterName $cluster `
        -ResourceGroupName $resourceGroup `
        -Name $extensionname `
        -ExtensionParameterPublisher $publisherName `
        -ExtensionParameterType $extensionType `
        -ExtensionParameterSetting $settingsConfig
        -NoWait 
}
