module "existing_subscription" {
  source = "../.."

  parent_management_group_id = "/providers/Microsoft.Management/managementGroups/example"
  vending_machine            = "existing"

  tags = {
    "tag1" = "value"
  }

  vending_machine_config = {
    subscription_id = "00000000-0000-0000-0000-000000000000"
  }
}
