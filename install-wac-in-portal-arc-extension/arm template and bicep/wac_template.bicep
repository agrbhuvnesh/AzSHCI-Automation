param clusterNames array
param port string

resource clusterNames_name_default_AdminCenter 'Microsoft.AzureStackHCI/clusters/arcSettings/extensions@2022-12-01' = [for item in clusterNames: {
  name: '${item.name}/default/AdminCenter'
  properties: {
    extensionParameters: {
      publisher: 'Microsoft.AdminCenter'
      type: 'AdminCenter'
      autoUpgradeMinorVersion: false
      enableAutomaticUpgrade: true
      settings: {
        port: port
      }
    }
  }
}]