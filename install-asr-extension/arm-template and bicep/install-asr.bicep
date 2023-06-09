@description('The names of the Azure Stack HCI clusters where the extension will be installed')
param clusterNames array

@description('SiteId of the recovery vault to be used while installing extension')
param recoverySiteId string

@description('Name of the recovery site to be used while installing extension')
param recoverySiteName string

@description('Private endpoint state for site recovery. Allowed values: None, Pending, Approved, Rejected, Disconnected, Timeout, Ready, or Unknown')
param privateEndpointStateForSiteRecovery string = 'None'

@description('Recovery Vault Name')
param recoveryServicesVaultName string

@description('Resource Group of the Recovery Vault')
param recoveryServicesVaultResourceGroup string

@description('Location of the Recovery Vault')
param recoveryServicesVaultLocation string

var publisher = 'Microsoft.SiteRecovery.Dra'
var type = 'Windows'
var environment = 'AzureCloud'

resource clusterNames_name_default_AzureSiteRecovery 'Microsoft.AzureStackHCI/clusters/arcSettings/extensions@2023-02-01' = [for item in clusterNames: {
  name: '${item.name}/default/AzureSiteRecovery'
  properties: {
    extensionParameters: {
      publisher: publisher
      type: type
      autoUpgradeMinorVersion: false
      settings: {
        SubscriptionId: subscription()
        Environment: environment
        ResourceGroup: recoveryServicesVaultResourceGroup
        ResourceName: recoveryServicesVaultName
        Location: recoveryServicesVaultLocation
        SiteId: recoverySiteId
        SiteName: recoverySiteName
        PrivateEndpointStateForSiteRecovery: privateEndpointStateForSiteRecovery
      }
      protectedSettings: {}
    }
  }
}]