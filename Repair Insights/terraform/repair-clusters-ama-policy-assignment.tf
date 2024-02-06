resource "azurerm_subscription_policy_assignment" "repair_clusters_ama_policy_assignment_subscription" {
  name                 = "subscription_repair_clusters_ama_policy_assignment"
  subscription_id = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_definition.repair_cluster_ama.id
  description          = "Policy Assignment for Repairing HCI Cluster with Old AMA configuration"
  display_name         = "Repair HCI Cluster with Old AMA configuration"
  location             = var.policy_assignment_location
  identity {
    type = "UserAssigned"
    identity_ids = [
      data.azurerm_user_assigned_identity.repair_clusters_policy_user_assigned_identity.id
    ]
  }

  non_compliance_message {
    content = "HCI cluster has old AMA configuration"
  }

  parameters = jsonencode({
    
    IncludeArcMachines = {
      value = "true"
    }

  })
}

# For each resource group name create resource group policy assignments
resource "azurerm_resource_group_policy_assignment" "repair_clusters_ama_policy_assignment_rgs" {
  for_each             = toset(local.policy_assignment_resource_group_list)
  name                 = lower("hcipolassign_${each.value}")
  display_name         = "repair_${each.value}_Repair HCI Cluster with Old AMA configuration"
  description          = "RG - Policy Assignment for Repairing HCI Cluster with Old AMA configuration"
  location             = var.policy_assignment_location
  resource_group_id    = data.azurerm_resource_group.policy_assignment_rgs[each.key].id
  policy_definition_id = azurerm_policy_definition.repair_cluster_ama.id
  enforce              = true
  identity {
    type = "UserAssigned"
    identity_ids = [
      data.azurerm_user_assigned_identity.repair_clusters_policy_user_assigned_identity.id
    ]
  }
  non_compliance_message {
    content = "HCI cluster has old AMA configuration"
  }

  parameters = jsonencode({
    
  })
}

