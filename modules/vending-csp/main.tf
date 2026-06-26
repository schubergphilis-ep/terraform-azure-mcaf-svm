resource "restful_operation" "subscription" {
  path   = "/api/create-subscription"
  method = "POST"

  body = {
    SubscriptionName = var.config.name
    SkuId            = var.config.sku == "Production" ? "0001" : "0002"
  }

  poll = {
    url_locator       = "header.Location"
    status_locator    = "code"
    default_delay_sec = 15
    status = {
      success = "200"
      pending = ["202"]
    }
  }

  lifecycle {
    ignore_changes = [body]
  }
}

data "restful_resource" "subscription_metadata" {
  id     = "/api/create-subscription/${restful_operation.subscription.output}"
  method = "GET"
}

locals {
  csp_response             = jsondecode(data.restful_resource.subscription_metadata.output)
  subscription_id          = local.csp_response.subscription.Id
  subscription_resource_id = "/subscriptions/${local.subscription_id}"
}

resource "azurerm_management_group_subscription_association" "this" {
  management_group_id = var.parent_management_group_id
  subscription_id     = local.subscription_resource_id
}
