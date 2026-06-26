output "subscription_id" {
  description = "Id (GUID) of the subscription."
  value       = azapi_resource.subscription.output.subscriptionId
}

output "display_name" {
  description = "Display name of the subscription."
  value       = azapi_resource.subscription.output.displayName
}

output "subscription_resource_id" {
  description = "Resource id of the subscription."
  value       = "/subscriptions/${azapi_resource.subscription.output.subscriptionId}"
}
