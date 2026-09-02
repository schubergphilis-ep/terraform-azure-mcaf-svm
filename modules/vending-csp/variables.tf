variable "config" {
  description = <<DESCRIPTION
    CSP (Cloud Solution Provider) subscription vending configuration.

    ```
    config = {
      name = "Display name of the subscription to create."
      sku  = "Subscription workload type ('Production' or 'DevTest'). Defaults to 'Production'."
    }
    ```
    DESCRIPTION

  type = object({
    name = string
    sku  = optional(string, "Production")
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
  nullable    = false
}
