$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""
$enableAutomaticUpgrade = $true
$apiVersion = "2023-03-01"

Connect-AzAccount -Subscription $subscriptionId -Tenant $tenantId

$clusters = Get-AzResource -ResourceGroupName $resourceGroup -ResourceType "Microsoft.AzureStackHCI/clusters" | Select-Object -ExpandProperty ResourceId

$extensions = foreach ($cluster in $clusters) {
    Get-AzResource -ResourceId "$cluster/arcSettings/default/extensions"
}

foreach ($extension in $extensions) {
    if ($extension.Properties.extensionParameters.type -eq "MicrosoftMonitoringAgent") {
        Write-Host "Skipping extension MicrosoftMonitoringAgent with id $extension.ResourceId"

        continue
    }

    if ($extension.Properties.managedBy -eq "Azure") {
        Write-Host "Skipping Azure managed extension with id $extension.ResourceId"

        continue
    }

    $updatedExtension = @{
        "name" = $extension.Name;
        "properties" = @{
            "extensionParameters" = $extension.Properties.extensionParameters
        }
    }
    $updatedExtension.properties.extensionParameters.enableAutomaticUpgrade = $enableAutomaticUpgrade

    $payload = $updatedExtension | ConvertTo-Json -Depth 10
    $path = $extension.ResourceId + "?api-version=" + $apiVersion

    Write-Host ("Setting automatic upgrades to $enableAutomaticUpgrade on extension $extension.ResourceId")

    Invoke-AzRestMethod `
        -Path $path `
        -Method PUT `
        -Payload $payload `
        -AsJob
}