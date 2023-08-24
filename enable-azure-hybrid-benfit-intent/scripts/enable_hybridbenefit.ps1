$subscription = ""
$resourceGroup = ""
$tenant = ""


##Powershell 
Connect-AzAccount -Tenant $tenant
Set-AzContext -Subscription $subscription
$clusters = Get-AzResource  -ResourceGroupName  $resourceGroup -ResourceType "Microsoft.AzureStackHCI/clusters" | Select-Object -ExpandProperty Name

#Enable Hybrid benefit for all clusters in a resource group
Foreach ($cluster in $Clusters) {
    
        "Enabling Azure Hybrid Benefit for cluster $cluster"
        Invoke-AzStackHciExtendClusterSoftwareAssuranceBenefit `
                                    -ClusterName $cluster `
                                    -ResourceGroupName $resourceGroup `
                                    -SoftwareAssuranceIntent "Enable"
}

#Enable Hybrid benefit for a particular cluster in a resource group

$clusterName = ""
Invoke-AzStackHciExtendClusterSoftwareAssuranceBenefit `
                                    -ClusterName $clusterName `
                                    -ResourceGroupName $resourceGroup `
                                    -SoftwareAssuranceIntent "Enable"
#CLI 

az login --tenant $tenant
az account set --subscription $subscription

$clusters = az stack-hci cluster list --resource-group $resourceGroup --query "[].id" -o tsv

#Enable Hybrid benefit for all clusters in a resource group

az stack-hci cluster extend-software-assurance-benefit `
                                    --ids $clusters `
                                    --resource-group $resourceGroup `
                                    --software-assurance-intent "enable"

#Enable Hybrid benefit for a particular cluster in a resource group

$clusterName = ""

az stack-hci cluster extend-software-assurance-benefit `
                                    --cluster-name $clusterName `
                                    --resource-group $resourceGroup `
                                    --software-assurance-intent "enable"
    
 