# Split the comma-separated resource group names into a list
locals {
  policy_assignment_resource_group_list = split(",", var.policy_assignment_rg_names)
}

# Create a tf data for each resource group name
data "azurerm_resource_group" "policy_assignment_rgs" {
  for_each = toset(local.policy_assignment_resource_group_list)
  name     = each.value
}

