variable "config" {
  description = <<DESCRIPTION
    EA (Enterprise Agreement) subscription vending configuration.

    ```
    config = {
      billing_account_name    = "Billing account name of the Enterprise Agreement."
      enrollment_account_name = "Enrollment account name within the above billing account."
      name                    = "Display name of the subscription to create."
      owner_id                = "Object ID of the subscription owner."
      sku                     = "Subscription workload type ('Production' or 'DevTest'). Defaults to 'Production'."
      tenant_id               = "Tenant ID the subscription should be associated with."
    }
    ```
    DESCRIPTION

  type = object({
    billing_account_name    = string
    enrollment_account_name = string
    name                    = string
    owner_id                = string
    sku                     = optional(string, "Production")
    tenant_id               = string
  })
  nullable = false

  validation {
    condition     = contains(["Production", "DevTest"], var.config.sku)
    error_message = "config.sku must be either 'Production' or 'DevTest'"
  }
}

variable "parent_management_group_id" {
  description = "Id of the parent management group the new subscription should be placed under."
  type        = string
  default     = null
}
