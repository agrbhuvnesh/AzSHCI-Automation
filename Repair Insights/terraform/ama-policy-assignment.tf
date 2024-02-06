# create Policy Assignment for default maintenance configuration at subscription level
resource "azurerm_subscription_policy_assignment" "ama_policy_assignment_subcription" {
  name                 = "subscription_install_ama_policy_assignment"
  subscription_id = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_definition.install_ama.id
  description          = "Policy Assignment for installing Azure Monitor Agent on HCI cluster"
  display_name         = "Subscription - Install Azure Monitor Agent on HCI cluster"
  location             = var.policy_assignment_location
  identity {
    type = "UserAssigned"
    identity_ids = [
      data.azurerm_user_assigned_identity.ama_dcr_policy_user_assigned_identity.id
    ]
  }

  non_compliance_message {
    content = "HCI cluster does not have Azure Monitor Agent installed"
  }

  parameters = jsonencode({
    

  })
}

# For each resource group name create resource group policy assignments
resource "azurerm_resource_group_policy_assignment" "ama_policy_assignment_rgs" {
  for_each             = toset(local.policy_assignment_resource_group_list)
  name                 = lower("amapolassign_${each.value}")
  display_name         = "ama_${each.value}_Install Azure Monitor Agent on HCI cluster"
  description          = "RG - Policy Assignment for installing Azure Monitor Agent on HCI cluster"
  location             = var.policy_assignment_location
  resource_group_id    = data.azurerm_resource_group.policy_assignment_rgs[each.key].id
  policy_definition_id = azurerm_policy_definition.install_ama.id
  enforce              = true
  identity {
    type = "UserAssigned"
    identity_ids = [
      data.azurerm_user_assigned_identity.repair_clusters_policy_user_assigned_identity.id
    ]
  }
  non_compliance_message {
    content = "HCI cluster does not have Azure Monitor Agent installed"
  }

  parameters = jsonencode({
    
  })
}

