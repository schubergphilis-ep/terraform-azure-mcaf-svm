output "subscription_id" {
  description = "Id (GUID) of the subscription."
  value       = data.azurerm_subscription.this.subscription_id
}

output "display_name" {
  description = "Display name of the subscription."
  value       = data.azurerm_subscription.this.display_name
}

output "subscription_resource_id" {
  description = "Resource id of the subscription."
  value       = data.azurerm_subscription.this.id
}
