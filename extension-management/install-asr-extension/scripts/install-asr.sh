# Load from Json file
variables=$(jq '.' variables.json)

# Assign variables
subscriptionId=$(echo "$variables" | jq -r '.subscriptionId')
resourceGroup=$(echo "$variables" | jq -r '.resourceGroup')
tenantID=$(echo "$variables" | jq -r '.tenantId')
parametersFilePath="./asr-parameters.json"
arcsettingname="default"
extensionname="ASRExtension"
publisherName="Microsoft.SiteRecovery.Dra"
extensionType="Windows"
autoUpgrade=true

# Using Command Line Interface (CLI)

# Login using Azure Active Directory
az login --tenant $tenantID
az account set -s $subscriptionId

# Get all clusters in the resource group
echo "Getting all clusters in the resource group"
clusters=$(az stack-hci cluster list --resource-group $resourceGroup --query "[].name" -o tsv)

# Install ASR extension for each cluster
echo "Installing ASR extension for each cluster"
for currentCluster in $clusters; do
    echo "Installing ASR extension for cluster $currentCluster"
    az stack-hci extension create \
        --arc-setting-name $arcsettingname \
        --cluster-name $currentCluster \
        --extension-name $extensionname \
        --resource-group $resourceGroup \
        --auto-upgrade $autoUpgrade \
        --publisher $publisherName \
        --type $extensionType \
        --settings @$parametersFilePath
done
