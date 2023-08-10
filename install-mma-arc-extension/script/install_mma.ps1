$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""

 

$Settings=@{

 

  "workspaceId"= ""

 

}

 

 

$protectedSetting=@{
  "workspaceKey"= ""
}

 

# Using CLI

 

$_ = az login --tenant $tenantId
$_ = az account set -s  $subscriptionId

 

$clusters = @(az stack-hci cluster list --resource-group $resourceGroup --query "[].name" -o tsv)

 

for ($i = 0; $i -lt $clusters.Count; $i++) {
    $currentCluster = $clusters[$i]
     Start-Job -ScriptBlock{
        Write-Host ("Installing MMA extension for cluster $using:currentCluster")

 

		az stack-hci extension create --arc-setting-name "default" --cluster-name $using:currentCluster --extension-name "MicrosoftMonitoringAgent" --resource-group $using:resourceGroup --auto-upgrade true --publisher "Microsoft.EnterpriseCloud.Monitoring" --type "MicrosoftMonitoringAgent" --settings "{workspaceId:<workspaceId>}" --protected-settings "{workspaceKey:<workspaceKey>}" --type-handler-version "1.10"

 

    } 
}

 

# Using Powershell

 

Connect-AzAccount -Tenant $tenantId
set-AzContext -Subscription $subscriptionId

 

$clusters = @(Get-AzStackHciCluster -ResourceGroupName $resourceGroup).Name

 


foreach($cluster in $clusters) {
     Start-Job -ScriptBlock{
        Write-Host ("Installing MMA extension for cluster $cluster")

 

        New-AzStackHciExtension -ClusterName $using:cluster -ResourceGroupName $using:resourceGroup -ArcSettingName "default" -Name "MicrosoftMonitoringAgent" -ExtensionParameterAutoUpgradeMinorVersion  -ExtensionParameterPublisher "Microsoft.EnterpriseCloud.Monitoring" -ExtensionParameterType "MicrosoftMonitoringAgent" -ExtensionParameterSetting $using:settings -ExtensionParameterProtectedSetting $using:protectedSetting -ExtensionParameterTypeHandlerVersion "1.10"

 

    }
}