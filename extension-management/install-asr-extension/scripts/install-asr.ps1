$tenantID = ""
$subscriptionId = ""
$resourceGroup = ""
$parametersFilePath = "path to asr parameters file" 
$arcsettingname = "default"
$extensionname = "ASRExtension"
$publisherName = "Microsoft.SiteRecovery.Dra"
$extensionType = "Windows"
$autoUpgrade = $true

# Using Command Line Interface (CLI)

# Login using Azure Active Directory
az login --tenant $tenantID
az account set -s  $subscriptionId

# Get all clusters in the resource group
"Getting all clusters in the resource group"
$clusters = az stack-hci cluster list --resource-group $resourceGroup --query "[].name" -o tsv

# Install ASR extension for each cluster
"Installing ASR extension for each cluster"
foreach ($currentCluster in $clusters) {
    Write-Host ("Installing ASR extension for cluster $currentCluster")
    az stack-hci extension create `
        --arc-setting-name $arcsettingname `
        --cluster-name $currentCluster `
        --extension-name $extensionname `
        --resource-group $resourceGroup `
        --auto-upgrade $autoUpgrade `
        --publisher $publisherName`
        --type $extensionType `
        --settings @$parametersFilePath `
}

# Using Powershell

# Login using Azure Active Directory
Connect-AzAccount -Tenant $tenantID
set-AzContext -Subscription $subscriptionId

# Extract ASR Properties from the file
"Extracting ASR Properties from the file"
 $asrProperties = @{}
 (Get-Content $parametersFilePath -Raw| ConvertFrom-Json).psobject.properties | Foreach { $asrProperties[$_.Name] = $_.Value }

# Get all clusters in the resource group
"Getting all clusters in the resource group"
$resourceType = "Microsoft.AzureStackHCI/clusters"
$clusters = Get-AzResource -ResourceGroupName $resourceGroup -ResourceType $resourceType | Select-Object -ExpandProperty Name
 
# Install ASR extension for each cluster
"Installing ASR extension for each cluster"
foreach ($cluster in $clusters) {
    Write-Host ("Installing ASR extension for cluster $cluster")
    New-AzStackHciExtension `
        -ClusterName $cluster `
        -ResourceGroupName $resourceGroup `
        -ArcSettingName $arcsettingname `
        -Name $extensionname `
        -ExtensionParameterPublisher $publisherName `
        -ExtensionParameterType $extensionType `
        -ExtensionParameterSetting $asrProperties
        -NoWait
}