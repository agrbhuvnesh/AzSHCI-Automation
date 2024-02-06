# Variables needed to identity details/existing resources needed for the policy assignments
policy_assignment_location = "West Europe"
policy_assignment_rg_names = "terraform-backend-policy-test-rg"
user_assigned_identity_name = "tf-policy-assignment-mi"
user_assigned_identity_rg = "terraform-backend-policy-test-rg"
user_assigned_identity_name_repair = "tf-policy-assignment-mi"
user_assigned_identity_rg_repair = "terraform-backend-policy-test-rg"

# Variables needed to identity existing resources needed for Data Collection Rule Creation
data_collection_rule_rg = "terraform-backend-policy-test-rg"
log_analytics_workspace_name = "tf-stack-hci-dcr-test-law"
log_analytics_workspace_rg = "terraform-backend-policy-test-rg"