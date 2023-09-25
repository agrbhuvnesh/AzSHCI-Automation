$subscriptionId = ""
$resourceGroup = ""
$tenantId = ""
$location = "eastus" 
$IMDSStatus = "Enabled"
$softwareStatus = "Enabled"

# Using Powershell

# Login using Azure Active Directory
Connect-AzAccount -Tenant $tenantId
Set-AzContext -Subscription $subscriptionId

# Get clusters with IMDS attestation specified
"Get clusters with IMDS attestation $IMDSStatus"
Get-AzStackHciCluster -ResourceGroupName $resourceGroup | Where-Object ReportedPropertyImdsAttestation -eq $IMDSStatus | Select-Object Name, Id, location

# Get clusters in location specified
"Get clusters in location $location"
Get-AzStackHciCluster -ResourceGroupName $resourceGroup | Where-Object location -eq $location | Select-Object Name, Id

# Using Command Line Interface (CLI)

# Login using Azure Active Directory
$login = az login --tenant $tenantId
az account set -s  $subscriptionId

# Get clusters in location specified
"Get clusters in location $location"
az stack-hci cluster list --resource-group $resourceGroup --query "[?location=='$location'].{Name:name, Id:id}" -o table

# Get clusters with software assurance specified
"Get clusters with software assurance $softwareStatus"
az stack-hci cluster list --resource-group $resourceGroup --query "[?softwareAssuranceProperties.softwareAssuranceIntent=='$softwareStatus'].{Name:name, Id:id}" -o table
