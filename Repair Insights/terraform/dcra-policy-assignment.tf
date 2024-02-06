resource "azurerm_subscription_policy_assignment" "dcra_policy_assignment_subscription" {
  name                 = "subscription_dcra_policy_assignment"
  subscription_id = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_definition.dcra_policy_defintion.id
  description          = "Policy Assignment for data collection rule association with HCI cluster nodes"
  display_name         = "Subscription - Policy Assignment for data collection rule association with HCI cluster nodes"
  location             = var.policy_assignment_location
  identity {
    type = "UserAssigned"
    identity_ids = [
      data.azurerm_user_assigned_identity.ama_dcr_policy_user_assigned_identity.id
    ]
  }

  non_compliance_message {
    content = "Node does not have correct data collection rule association"
  }

  parameters = jsonencode({
    
    dcrResourceId = {
      value = azurerm_monitor_data_collection_rule.data_collection_rule.id
    }

  })
}


# For each resource group name, create resource group policy assignment
resource "azurerm_resource_group_policy_assignment" "deploy_ama_az_stack_hci_policy" {
  for_each             = toset(local.policy_assignment_resource_group_list)
  name                 = lower("dcrapolassign_${each.value}")
  display_name         = "dcra_${each.value}_Associate Data Collection Rule with HCI cluster nodes"
  description          = "RG - Policy Assignment for data collection rule association with HCI cluster nodes"
  location             = var.policy_assignment_location
  resource_group_id    = data.azurerm_resource_group.policy_assignment_rgs[each.key].id
  policy_definition_id = azurerm_policy_definition.dcra_policy_defintion.id
  enforce              = true
  identity {
    type = "UserAssigned"
    identity_ids = [
      data.azurerm_user_assigned_identity.repair_clusters_policy_user_assigned_identity.id
    ]
  }
  non_compliance_message {
    content = "Node does not have correct data collection rule association."
  }

  parameters = jsonencode({
    dcrResourceId = {
      value = azurerm_monitor_data_collection_rule.data_collection_rule.id
    }
  })
}