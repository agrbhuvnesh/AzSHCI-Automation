variable "user_assigned_identity_name" {
  description = "The ID of the User Assigned Identity"
  type        = string
}

variable "user_assigned_identity_rg" {
  description = "The resource group where the User Assigned Identity is located"
  type        = string
}

variable "user_assigned_identity_name_repair" {
  description = "The ID of the User Assigned Identity"
  type        = string
}

variable "user_assigned_identity_rg_repair" {
  description = "The resource group where the User Assigned Identity is located"
  type        = string
}

variable "policy_assignment_location" {
  description = "The location of the Azure Policy Assignment"
  type        = string
}

variable "policy_assignment_rg_names" {
  description = "The Names of Resource Groups (comma seperated) for which the Azure Policy will be created"
  type        = string
}

variable "data_collection_rule_rg" {
  description = "The resource group name of the data collection rule"
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace"
  type        = string
}

variable "log_analytics_workspace_rg" {
  description = "The resource group name of the Log Analytics Workspace"
  type        = string
}