provider "azurerm" {
  features {}
  skip_provider_registration = "true"
}

terraform {
  required_providers {
    azapi = {
      source = "azure/azapi"
    }
  }
}

provider "azapi" {
}


# Variables
variable "clusterResourceIds" {
  type        = list(string)
  description = "Resource Ids of the Azure Stack HCI clusters to install the Azure Monitoring Agent extension."
}

variable "location" {
  type        = string
  description = "Location where the data collection rule is to be created."
}

variable "workspaceId" {
  type        = string
  description = "Workspace Id of the workspace to be associated with AMA agent extension."
}

variable "workspaceName" {
  type        = string
  description = "Name of the Workspace to be associated with AMA agent extension."
}

variable "resourceGroupName" {
  type        = string
  description = "Name of the resource group where the log analytics workspace exists."
}

variable "azStackHCIApiVersion" {
  type        = string
  description = "The Azure Stack HCI Cluster api version to be used with azapi_resource"
}

variable "azStackHCIDataCollectionRuleAssociationApiVersion" {
  type        = string
  description = "The Azure Stack HCI Cluster data collection rule association api version to be used with azapi_resource"
}

# locals
locals {
  AMAExtensionName       = "AzureMonitorWindowsAgent"
  publisher              = "Microsoft.Azure.Monitor"
  dataCollectionRuleName = "${var.resourceGroupName}-DataCollectionRule"
}


# Existing resource group where log analytics workspace exists
data "azurerm_resource_group" "resourceGroup" {
  name = var.resourceGroupName
}

# Existing Azure Stack HCI Clusters
data "azapi_resource" "cluster" {
  for_each    = toset(var.clusterResourceIds)
  type        = "Microsoft.AzureStackHCI/clusters@${var.azStackHCIApiVersion}"
  resource_id = each.value
}


# Data Collection Rule
resource "azurerm_monitor_data_collection_rule" "data_collection_rule" {
  name                = local.dataCollectionRuleName
  location            = var.location
  resource_group_name = var.resourceGroupName
  tags = {
    tagName1 = "tagValue1"
    tagName2 = "tagValue2"
  }

  destinations {
    log_analytics {
      name                  = var.workspaceName
      workspace_resource_id = "${data.azurerm_resource_group.resourceGroup.id}/providers/Microsoft.OperationalInsights/workspaces/${var.workspaceName}"
    }
  }

  data_sources {
    performance_counter {
      counter_specifiers = [
        "\\Memory(*)\\Available Bytes",
        "\\Memory\\Available Bytes",
        "\\Network Interface(*)\\Bytes Total/sec",
        "\\Processor(_Total)\\% Processor Time",
        "\\RDMA Activity(*)\\RDMA Inbound Bytes/sec",
        "\\RDMA Activity(*)\\RDMA Outbound Bytes/sec",
      ]
      name                          = "perfCounterDataSource"
      sampling_frequency_in_seconds = 10
      streams                       = ["Microsoft-Perf"]
    }

    windows_event_log {
      name    = "eventLogsDataSource"
      streams = ["Microsoft-Event"]

      x_path_queries = [
        "Microsoft-Windows-SDDC-Management/Operational!*[System[(EventID=3000 or EventID=3001 or EventID=3002 or EventID=3003 or EventID=3004)]]",
        "microsoft-windows-health/operational!*",
      ]
    }
  }

  data_flow {
    destinations = [var.workspaceName]
    streams      = ["Microsoft-Perf"]
  }

  data_flow {
    destinations = [var.workspaceName]
    streams      = ["Microsoft-Event"]
  }

  description = "Data Collection Rule for Azure Monitoring Agent Arc extension."
}

# Azure Stack HCI cluster extensions
resource "azapi_resource" "azurestackhci_cluster_extension" {
  for_each  = toset(var.clusterResourceIds)
  type      = "microsoft.azurestackhci/clusters/arcsettings/extensions@${var.azStackHCIApiVersion}"
  name      = "AzureMonitorWindowsAgent"
  parent_id = "${data.azapi_resource.cluster[each.key].id}/arcSettings/default"
  body = jsonencode({
    properties = {
      extensionParameters = {

        publisher = local.publisher
        type      = local.AMAExtensionName
      }
    }
  })
}

# Data Collection Rule Association
resource "azapi_resource" "data_collection_rule_associations" {
  for_each  = toset(var.clusterResourceIds)
  type      = "Microsoft.Insights/dataCollectionRuleAssociations@${var.azStackHCIDataCollectionRuleAssociationApiVersion}"
  name      = "dcrassociation"
  parent_id = data.azapi_resource.cluster[each.key].id
  body = jsonencode({
    properties = {
      dataCollectionRuleId = azurerm_monitor_data_collection_rule.data_collection_rule.id
      description          = "Association of data collection rule. Deleting this association will break the data collection for this cluster"
    }
  })
  depends_on = [azapi_resource.azurestackhci_cluster_extension]
}