$variables = Get-Content "./variables.json" | ConvertFrom-Json

$subscriptionId = $variables.subscriptionId
$resourceGroup = $variables.resourceGroup
$tenantId = $variables.tenantId
 

# Using Powershell

Connect-AzAccount -Tenant $tenantId
set-AzContext -Subscription $subscriptionId

$settings=@{
  "workspaceId"= ""
}
 

$protectedSetting=@{
  "workspaceKey"= ""
}

$clusters = Get-AzResource -ResourceGroupName $resourceGroup -ResourceType "Microsoft.AzureStackHCI/clusters" | Select-Object -ExpandProperty Name

foreach($cluster in $clusters) {
     
        Write-Host ("Installing MMA extension for cluster $cluster")

        New-AzStackHciExtension `
                -ClusterName $cluster `
                -ResourceGroupName $resourceGroup `
                -ArcSettingName "default" `
                -Name "MicrosoftMonitoringAgent" `
                -ExtensionParameterAutoUpgradeMinorVersion  `
                -ExtensionParameterPublisher "Microsoft.EnterpriseCloud.Monitoring" `
                -ExtensionParameterType "MicrosoftMonitoringAgent" `
                -ExtensionParameterSetting $settings `
                -ExtensionParameterProtectedSetting $protectedSetting `
                -ExtensionParameterTypeHandlerVersion "1.10"
}