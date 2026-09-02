module "ea_subscription" {
  source = "../.."

  vending_machine = "ea"

  tags = {
    "tag1" = "value"
  }

  vending_machine_config = {
    billing_account_name    = "1234567890"
    enrollment_account_name = "0123456"
    name                    = "sub-ea-test"
    owner_id                = "00000000-0000-0000-0000-000000000000"
    sku                     = "Production"
    tenant_id               = "00000000-0000-0000-0000-000000000000"
  }
}
