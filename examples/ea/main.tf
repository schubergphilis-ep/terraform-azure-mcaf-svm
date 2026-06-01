module "ea_subscription" {
  source          = "../.."
  name            = "sub-ea-test"
  vending_machine = "ea"
  sku             = "Production"
  tags            = { "tag1" = "value" }
  owner_id        = "00000000-0000-0000-0000-000000000000"
  tenant_id       = "00000000-0000-0000-0000-000000000000"
  ea_billing_details = {
    billing_account_name    = "1234567890"
    enrollment_account_name = "0123456"
  }
}
