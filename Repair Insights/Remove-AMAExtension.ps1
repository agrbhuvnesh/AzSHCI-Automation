$tenant = ""
$subscriptionIds = @("subscriptionId1", "subscriptionId2", "subscriptionId3") # Add your subscription IDs here

Connect-AzAccount -Tenant $tenant -UseDeviceAuthentication

foreach ($subscriptionId in $subscriptionIds) {
    Set-AzContext -SubscriptionId $subscriptionId

    $resource_groups = Get-AzResourceGroup -Name "*_S[V|N|Q|W|S|T][0-9]{4}_" | Select-Object -ExpandProperty ResourceGroupName
    Write-Host("Resource Groups found: ", $resource_groups)

    foreach ($resourceGroup in $resource_groups)
    {
        $resourceType = "Microsoft.AzureStackHCI/clusters" 
        $clusters = Get-AzResource -ResourceGroupName $resourceGroup -ResourceType $resourceType | Select-Object -ExpandProperty Name
        Write-Host ("For resource group: " + $resourceGroup + ", AMA Extension will be uninstalled for clusters: " + $clusters)
    }

    foreach ($resourceGroup in $resource_groups) {
        $resourceType = "Microsoft.AzureStackHCI/clusters" 
        $clusters = Get-AzResource -ResourceGroupName $resourceGroup -ResourceType $resourceType | Select-Object -ExpandProperty Name
        $clustersAMAUninstallSuccess = @()
        $clustersAMAUninstallFailed = @()
        foreach ($clusterName in $clusters) {
            Write-Host ("Uninstalling AMA extension for cluster: ", $clusterName)

            $maxTryAttempt = 10
            Remove-AzStackHCIExtension `
                -ClusterName $clusterName `
                -ArcSettingName "default" `
                -Name "AzureMonitorWindowsAgent" `
                -ResourceGroupName $resourceGroup

            # once the extension is deleted, it will throw a resource not found error 
            try {
                $extensionDeleted = $false
                do {
                    Start-Sleep -Seconds 10
                    Write-Host ("Checking extension status for cluster: ", $clusterName)
                    $state = (Get-AzStackHciExtension -ClusterName $clusterName -Name "AzureWindowsMonitoringAgent" -ResourceGroupName $resourceGroup -ArcSettingName default -ErrorAction Stop).ProvisioningState
                    Write-Host ("Extension's state: ", $state)
                    $maxTryAttempt -= 1
                } while ((!$extensionDeleted) -and ($maxTryAttempt -gt 0))
            }
            catch {
                if($_.Exception.Message.Contains("ResourceNotFound"))
                {
                    $extensionDeleted = $true
                    Write-Host("Extension deleted successfully for cluster: ", $clusterName)
                    $clustersAMAUninstallSuccess += $clusterName
                }
                else
                {
                    Write-Host ($_.Exception)
                    Write-Host("Extension NOT deleted for cluster: ", $clusterName)
                    $clustersAMAUninstallFailed += $clusterName
                } 
            }
            if($maxTryAttempt -le 0)
            {
                $state = (Get-AzStackHciExtension -ClusterName $clusterName -Name "AzureWindowsMonitoringAgent" -ResourceGroupName $resourceGroup -ArcSettingName default -ErrorAction Stop).ProvisioningState
                Write-Host("Extension in state: " + $state + " for cluster: " + $clusterName)
                $clustersAMAUninstallFailed += $clusterName
            }
        }
    }
    Write-Host ("For subscriptionId: ", $subscriptionId)
    Write-Host ("Clusters with AMA uninstallation successful: ", $clustersAMAUninstallSuccess)
    Write-Host ("Clusters with AMA uninstallation failed: ", $clustersAMAUninstallFailed)
    Write-Host ("-----------------------------------------------------------------------------------------------")
}