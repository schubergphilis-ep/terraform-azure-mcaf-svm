output "display_name" {
  description = "Display name of the subscription."
  value       = module.vending.display_name
}

output "id" {
  description = "Resource id of the subscription."
  value       = module.vending.subscription_resource_id
}

output "subscription_id" {
  description = "Id (GUID) of the subscription."
  value       = module.vending.subscription_id
}
