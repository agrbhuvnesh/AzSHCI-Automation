$variables = Get-Content "./variables.json" | ConvertFrom-Json

$subscriptionId = $variables.subscriptionId
$resourceGroup = $variables.resourceGroup
$tenantId = $variables.tenantId
$extensionName = $variables.extensionName
$apiVersion = "2023-03-01"

$extensionPayload = Get-Content -Path ".\extension-payload.json" -Raw

Connect-AzAccount -Subscription $subscriptionId -Tenant $tenantId

$clusters = Get-AzResource -ResourceGroupName $resourceGroup -ResourceType "Microsoft.AzureStackHCI/clusters" | Select-Object -ExpandProperty Name

for ($i = 0; $i -lt $clusters.Count; $i++) {
    $currentCluster = $clusters[$i]

    if ($extensionName -eq "AdminCenter") {
        Write-Host ("Enabling Connectivity for cluster $currentCluster")
        
        Invoke-AzRestMethod `
            -SubscriptionId $subscriptionId `
            -ResourceGroupName $resourceGroup `
            -ResourceProviderName "Microsoft.AzureStackHCI" `
            -ResourceType @("clusters", "arcSettings") `
            -Name @($currentCluster, "default")  `
            -ApiVersion $apiVersion`
            -Method PUT `
            -Payload (@{"properties" = @{ "connectivityProperties" = @{ "enabled" = $true } } } | ConvertTo-Json -Depth 5)
    }

    Write-Host ("Installing $extensionName extension for cluster $currentCluster")

    Invoke-AzRestMethod `
        -SubscriptionId $subscriptionId `
        -ResourceGroupName $resourceGroup `
        -ResourceProviderName "Microsoft.AzureStackHCI" `
        -ResourceType @("clusters", "arcSettings", "extensions") `
        -Name @($currentCluster, "default", $extensionName)  `
        -ApiVersion $apiVersion `
        -Method PUT `
        -Payload $extensionPayload `
        -AsJob
}