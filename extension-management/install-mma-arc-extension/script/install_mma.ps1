$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""

  

# Using CLI

 

$_ = az login --tenant $tenantId
$_ = az account set -s  $subscriptionId

 

$clusters = @(az stack-hci cluster list --resource-group $resourceGroup --query "[].name" -o tsv)

 

for ($i = 0; $i -lt $clusters.Count; $i++) {
    $currentCluster = $clusters[$i]
        Write-Host ("Installing MMA extension for cluster $currentCluster")

    #replace workspace id and workspave key with your own values
		az stack-hci extension create `
          --arc-setting-name "default" `
          --cluster-name $currentCluster `
          --extension-name "MicrosoftMonitoringAgent" `
          --resource-group $resourceGroup `
          --auto-upgrade true `
          --publisher "Microsoft.EnterpriseCloud.Monitoring" `
          --type "MicrosoftMonitoringAgent" `
          --settings "{workspaceId:<workspaceId>}" `
          --protected-settings "{workspaceKey:<workspaceKey>}" `
          --type-handler-version "1.10"

}

 

# Using Powershell

$Settings=@{

 

  "workspaceId"= ""

 

}

 

 

$protectedSetting=@{
  "workspaceKey"= ""
}

Connect-AzAccount -Tenant $tenantId
set-AzContext -Subscription $subscriptionId

 

$clusters = @(Get-AzStackHciCluster -ResourceGroupName $resourceGroup).Name

 


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