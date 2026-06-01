module "mca_subscription" {
  source          = "../.."
  name            = "sub-mca-test"
  vending_machine = "mca"
  sku             = "Production"
  tags            = { "tag1" = "value" }
  owner_id        = "00000000-0000-0000-0000-000000000000"
  tenant_id       = "00000000-0000-0000-0000-000000000000"
  parent_management_group_id = ""
  mca_billing_details = {
    billing_account_name = "Billing Account Name"
    billing_profile_name = "Billing Profile Name"
    invoice_section_name = "Invoice Section Name"
  }
}
