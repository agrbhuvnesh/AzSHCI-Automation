data "azurerm_user_assigned_identity" "repair_clusters_policy_user_assigned_identity" {
  name                = var.user_assigned_identity_name_repair
  resource_group_name = var.user_assigned_identity_rg_repair
}

data "azurerm_user_assigned_identity" "ama_dcr_policy_user_assigned_identity" {
  name                = var.user_assigned_identity_name
  resource_group_name = var.user_assigned_identity_rg
}