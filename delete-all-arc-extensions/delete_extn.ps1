
$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""


## USING CLI
$login = az login --tenant $tenantId
az account set -s  $subscriptionId

$clusters = az stack-hci cluster list --resource-group $resourceGroup --query "[].name" -o tsv




#Delete all extensions for all the clusters in the resource group

foreach ($currentCluster in $clusters) {
    
        "Deleting Arc Extensions for cluster $currentCluster"
		az resource delete  --ids (az stack-hci extension list `
                                    --arc-setting-name "default" `
                                    --cluster-name $currentCluster `
                                    --resource-group $resourceGroup `
                                    --subscription $subscriptionId `
                                    --query "[].id" -o tsv) 
	
}


#To delete a particular extension for all the clusters in the resource-group 
$extensionName = ""

foreach ($currentCluster in $clusters) {
    
        "Deleting Arc Extension $using:extensionName for cluster $using:currentCluster"
        az stack-hci extension delete `
            --arc-setting-name "default" `
            --name "${extensionName}" `
            --cluster-name "${currentCluster}" `
            --resource-group "${resourceGroup}"
}



##USING POWERSHELL

Connect-AzAccount -Tenant $tenantId -Subscription $subscriptionId
Set-AzContext -Subscription $subscriptionId

$clusterName = ""

#Delete all extensions for a cluster in the resource group
$extensions = (Get-AzStackHciExtension -ClusterName $clusterName -ResourceGroupName $resourceGroup -ArcSettingName "default").Name

foreach ($extension in $extensions) {
     {
        "Deleting Arc Extension $using:extensionName for cluster $currentCluster"
        Remove-AzStackHciExtension -ClusterName $using:clusterName -ResourceGroupName $using:resourceGroup -ArcSettingName "default" -Name $using:extension
    }
}

#Delete a particular extension for a cluster in the resource group
$extensionName = ""

Remove-AzStackHciExtension -ClusterName $clusterName `
                            -ResourceGroupName $resourceGroup `
                            -ArcSettingName "default" `
                            -Name $extensionName 
