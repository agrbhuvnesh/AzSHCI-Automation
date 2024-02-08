$variables = Get-Content "./variables.json" | ConvertFrom-Json

$subscriptionId = $variables.subscriptionId
$resourceGroup = $variables.resourceGroup
$tenantID = $variables.tenantId
$parametersFilePath = "./asr-parameters.json"
$extensionname = "ASRExtension"
$publisherName = "Microsoft.SiteRecovery.Dra"
$extensionType = "Windows"

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
        -ArcSettingName "default" `
        -Name $extensionname `
        -ExtensionParameterPublisher $publisherName `
        -ExtensionParameterType $extensionType `
        -ExtensionParameterSetting $asrProperties
        -NoWait
}