variable "name" {
  description = "Name of the Subscription to be created"
  type        = string
  nullable    = false
}

variable "tags" {
  description = "Tags to add to the subscription, only needed if channel is set to ea."
  type        = map(string)
  default     = null
}

variable "parent_management_group_id" {
  description = "The Id of the parent management group, only needed if channel is set to ea"
  type        = string
  default     = null
}

variable "vending_machine" {
  description = "Vending machine to be used by the subscription"
  type        = string
  nullable    = false

  validation {
    condition     = contains(["ea", "mca", "csp", "existing"], var.vending_machine)
    error_message = "The channel must be either 'ea', 'mca' or 'csp'"
  }
}

variable "subscription_id" {
  description = "The ID of the subscription if it already exists"
  type        = string
  default     = null

  validation {
    condition     = (var.vending_machine != "existing" && var.subscription_id == null) || (var.vending_machine == "existing" && var.subscription_id != null)
    error_message = "The value should only be provided if the vending_machine is 'existing'. If the vending_machine is 'existing' this value is required"
  }
}

variable "owner_id" {
  description = "Id of the subscription owner, only needed if channel is set to 'mca' or 'ea'."
  type        = string
  default     = null

  validation {
    condition     = (!contains(["mca", "ea"], var.vending_machine) && var.owner_id == null) || (contains(["mca", "ea"], var.vending_machine) && var.owner_id != null)
    error_message = "The value should only be provided if the vending_machine is 'ea' or 'mca'. If the vending_machine is 'ea' or 'mca' this value is required"
  }
}

variable "tenant_id" {
  description = "Id of the tenant to which the subscription should be associated, only needed if channel is set to 'mca' or 'ea'."
  type        = string
  default     = null

  validation {
    condition     = (!contains(["mca", "ea"], var.vending_machine) && var.tenant_id == null) || (contains(["mca", "ea"], var.vending_machine) && var.tenant_id != null)
    error_message = "The value should only be provided if the vending_machine is 'ea' or 'mca'. If the vending_machine is 'ea' or 'mca' this value is required"
  }
}

variable "sku" {
  description = "The SKU for the subscription that should be created"
  type        = string
  default     = "Production"

  validation {
    condition     = (var.vending_machine == "existing" && var.sku == null) || (var.vending_machine != "existing" && contains(["Production", "DevTest"], var.sku))
    error_message = "If the subscription needs to be created (vending_machine is not 'existing') this value is required and must be either 'Production' or 'DevTest'"
  }
}

variable "mca_billing_details" {
  description = <<DESCRIPTION
    Billing details for Microsoft Customer Agreement subscription vending

    ```
    mca_billing_details = {
      billing_account_name = "The Billing Account Name of the MCA account."
      billing_profile_name = "The Billing Profile Name in the above Billing Account."
      invoice_section_name = "The Invoice Section Name in the above Billing Profile."
    ```
    DESCRIPTION
  type = object({
    billing_account_name = string
    billing_profile_name = string
    invoice_section_name = string
  })
  default = null

  validation {
    condition     = (var.vending_machine != "mca" && var.mca_billing_details == null) || (var.vending_machine == "mca" && var.mca_billing_details != null)
    error_message = "The value should only be provided if the vending_machine is 'mca'. If the vending_machine is 'mca' this value is required"
  }
}

variable "ea_billing_details" {
  description = <<DESCRIPTION
    Billing details for Enterprise Agreement subscription vending

    ```
    ea_billing_details = {
      billing_account_name = "The Billing Account Name of the Enterprise Account."
      enrollment_account_name = "The Enrollment Account Name in the above Enterprise Account."
    ```
    DESCRIPTION
  type = object({
    billing_account_name    = string
    enrollment_account_name = string
  })
  default = null

  validation {
    condition     = (var.vending_machine != "ea" && var.ea_billing_details == null) || (var.vending_machine == "ea" && var.ea_billing_details != null)
    error_message = "The value should only be provided if the vending_machine is 'ea'. If the vending_machine is 'ea' this value is required"
  }
}
