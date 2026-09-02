module "csp_subscription" {
  source = "../.."

  parent_management_group_id = "/providers/Microsoft.Management/managementGroups/example"
  vending_machine            = "csp"

  vending_machine_config = {
    name = "sub-csp-test"
    sku  = "Production"
  }
}
