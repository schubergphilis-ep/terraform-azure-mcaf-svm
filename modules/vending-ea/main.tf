data "azurerm_billing_enrollment_account_scope" "this" {
  billing_account_name    = var.config.billing_account_name
  enrollment_account_name = var.config.enrollment_account_name
}

resource "azapi_resource" "subscription" {
  type      = "Microsoft.Subscription/aliases@2024-08-01-preview"
  name      = var.config.name
  parent_id = "/"
  body = {
    properties = {
      additionalProperties = {
        managementGroupId    = var.parent_management_group_id
        subscriptionOwnerId  = var.config.owner_id
        subscriptionTenantId = var.config.tenant_id
      }
      billingScope = data.azurerm_billing_enrollment_account_scope.this.id
      displayName  = var.config.name
      workload     = var.config.sku
    }
  }

  response_export_values = {
    subscriptionId = "properties.subscriptionId"
    displayName    = "name"
  }

  lifecycle {
    ignore_changes = [name, body]
  }
}
