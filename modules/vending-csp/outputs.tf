output "subscription_id" {
  description = "Id (GUID) of the subscription."
  value       = local.subscription_id
}

output "display_name" {
  description = "Display name of the subscription."
  value       = local.csp_response.subscription.name
}

output "subscription_resource_id" {
  description = "Resource id of the subscription."
  value       = local.subscription_resource_id
}
