$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""
$extensionName = ""

$extensionPayload = Get-Content -Path ".\extension-payload.json" -Raw

Connect-AzAccount -Subscription $subscriptionId -Tenant $tenantId

$clusters = Get-AzResource -ResourceGroupName $resourceGroup -ResourceType "Microsoft.AzureStackHCI/clusters" | Select-Object -ExpandProperty Name

for ($i = 0; $i -lt $clusters.Count; $i++) {
    $currentCluster = $clusters[$i]
    
    Write-Host ("Installing $extensionName extension for cluster $currentCluster")

    Invoke-AzRestMethod `
        -SubscriptionId $subscriptionId `
        -ResourceGroupName $resourceGroup `
        -ResourceProviderName "Microsoft.AzureStackHCI" `
        -ResourceType @("clusters", "arcSettings", "extensions") `
        -Name @($currentCluster, "default", $extensionName)  `
        -ApiVersion "2023-03-01" `
        -Method PUT `
        -Payload $extensionPayload `
        -AsJob
}