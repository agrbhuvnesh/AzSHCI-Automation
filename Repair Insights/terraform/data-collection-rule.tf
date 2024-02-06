
data "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_rg
}

resource "azurerm_monitor_data_collection_rule" "data_collection_rule" {
  name                        = "stack-hci-dcra"
  resource_group_name           = var.data_collection_rule_rg
  location                      = var.policy_assignment_location

  destinations {
    log_analytics {
      workspace_resource_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
      name                  = data.azurerm_log_analytics_workspace.log_analytics_workspace.name
    }
  }

  data_flow {
    streams      = ["Microsoft-Perf"]
    destinations = [data.azurerm_log_analytics_workspace.log_analytics_workspace.name]
  }

  data_flow {
    streams      = ["Microsoft-Event"]
    destinations = [data.azurerm_log_analytics_workspace.log_analytics_workspace.name]
  }


  data_sources {
    performance_counter {
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 10
      counter_specifiers            = ["\\Memory(*)\\Available Bytes",
                                        "\\Network Interface(*)\\Bytes Total/sec",
                                        "\\Processor(_Total)\\% Processor Time",
                                        "\\RDMA Activity(*)\\RDMA Inbound Bytes/sec",
                                        "\\RDMA Activity(*)\\RDMA Outbound Bytes/sec",
                                        "\\Memory\\Available Bytes"]
      name                          = "perfCounterDataSource"
    }

    windows_event_log {
      streams        = ["Microsoft-Event"]
      x_path_queries = ["Microsoft-Windows-SDDC-Management/Operational!*[S  ystem[(EventID=3000 or EventID=3001 or EventID=3002 or EventID=3003 or EventID=3004)]]",
                        "microsoft-windows-health/operational!*"]
      name           = "eventLogsDataSource"
    }
  }
}
