module "vending" {
  source = "./modules/vending-${var.vending_machine}"

  config                     = var.vending_machine_config
  parent_management_group_id = var.parent_management_group_id
}

resource "azapi_update_resource" "subscription_tags" {
  type        = "Microsoft.Resources/tags@2024-11-01"
  resource_id = "${module.vending.subscription_resource_id}/providers/Microsoft.Resources/tags/default"
  body = {
    properties = {
      tags = var.tags
    }
  }
}
