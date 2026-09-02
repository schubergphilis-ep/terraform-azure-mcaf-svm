data "azurerm_subscription" "this" {
  subscription_id = var.config.subscription_id
}

resource "azurerm_management_group_subscription_association" "this" {
  management_group_id = var.parent_management_group_id
  subscription_id     = data.azurerm_subscription.this.id
}
