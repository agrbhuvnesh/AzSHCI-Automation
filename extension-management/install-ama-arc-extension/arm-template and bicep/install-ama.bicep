@description('Names of the Azure Stack HCI clusters to install the Azure Monitoring Agent Arc extension on.')
param clusterNames array

@description('location where the resources are present')
param location string

@description('Workspace Id of the workspace to be associated with AMA agent extension')
param workspaceId string

@description('Name of the Workspace to be associated with AMA agent extension')
param workspaceName string

var AMAExtensionName = 'AzureMonitorWindowsAgent'
var publisher = 'Microsoft.Azure.Monitor'
var DataCollectionRuleName = '${resourceGroup().name}-DataCollectionRule'

resource DataCollectionRule 'Microsoft.Insights/dataCollectionRules@2021-09-01-preview' = {
  name: DataCollectionRuleName
  location: location
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  properties: {
    destinations: {
      logAnalytics: [
        {
          name: workspaceName
          workspaceId: workspaceId
          workspaceResourceId: '/subscriptions/${subscription().subscriptionId}/resourcegroups/${resourceGroup().name}/providers/microsoft.operationalinsights/workspaces/${workspaceName}'
        }
      ]
    }
    dataSources: {
      performanceCounters: [
        {
          counterSpecifiers: [
            '\\Memory(*)\\Available Bytes'
            '\\Network Interface(*)\\Bytes Total/sec'
            '\\Processor(_Total)\\% Processor Time'
            '\\RDMA Activity(*)\\RDMA Inbound Bytes/sec'
            '\\RDMA Activity(*)\\RDMA Outbound Bytes/sec'
          ]
          name: 'perfCounterDataSource'
          samplingFrequencyInSeconds: 10
          streams: [
            'Microsoft-Perf'
          ]
        }
      ]
      windowsEventLogs: [
        {
          name: 'eventLogsDataSource'
          streams: [
            'Microsoft-Event'
          ]
          xPathQueries: [
            'Microsoft-Windows-SDDC-Management/Operational!*[System[(EventID=3000 or EventID=3001 or EventID=3002 or EventID=3003 or EventID=3004)]]'
            'microsoft-windows-health/operational!*'
          ]
        }
      ]
    }
    dataFlows: [
      {
        destinations: [
          workspaceName
        ]
        streams: [
          'Microsoft-Perf'
        ]
      }
      {
        destinations: [
          workspaceName
        ]
        streams: [
          'Microsoft-Event'
        ]
      }
    ]
    description: 'Data Collection Rule for Azure Monitoring Agent Arc extension.'
  }
}

resource clusterNames_name_default_AzureMonitorWindowsAgent 'Microsoft.AzureStackHCI/clusters/arcSettings/extensions@2023-02-01' = [for item in clusterNames: {
  name: '${item.name}/default/AzureMonitorWindowsAgent'
  properties: {
    extensionParameters: {
      publisher: publisher
      type: AMAExtensionName
    }
  }
}]

resource clusters 'Microsoft.AzureStackHCI/clusters@2023-02-01' existing = [for item in clusterNames: {
  name: item.name
}]

resource clusterNames_name_dataCollectionRuleAssociations 'Microsoft.Insights/dataCollectionRuleAssociations@2021-09-01-preview' = [for (item,i) in clusterNames: {
  scope: clusters[i]
  name: '${item.name}dataCollectionRuleAssociations'
  properties: {
    description: 'Association of data collection rule. Deleting this association will break the data collection for this cluster'
    dataCollectionRuleId: DataCollectionRule.id
  }
  dependsOn: [
    clusterNames_name_default_AzureMonitorWindowsAgent
    DataCollectionRule
  ]
}]
