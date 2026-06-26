module "mca_subscription" {
  source = "../.."

  parent_management_group_id = ""
  vending_machine            = "mca"

  tags = {
    "tag1" = "value"
  }

  vending_machine_config = {
    billing_account_name = "Billing Account Name"
    billing_profile_name = "Billing Profile Name"
    invoice_section_name = "Invoice Section Name"
    name                 = "sub-mca-test"
    owner_id             = "00000000-0000-0000-0000-000000000000"
    sku                  = "Production"
    tenant_id            = "00000000-0000-0000-0000-000000000000"
  }
}
