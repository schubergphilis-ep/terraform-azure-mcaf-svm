module "csp_subscription" {
  source = "../.."

  vending_machine = "csp"
  name    = "sub-csp-test"
  sku     = "Production"
}
