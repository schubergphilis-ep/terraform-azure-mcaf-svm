variable "parent_management_group_id" {
  description = "Id of the parent management group the subscription should be placed under. Required for 'csp' and 'existing'; optional for 'ea' and 'mca' (where it is folded into the subscription alias body)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the subscription."
  type        = map(string)
  default     = null
}

variable "vending_machine" {
  description = "Vending machine that produces the subscription. One of 'ea', 'mca', 'csp', or 'existing'."
  type        = string
  const       = true
  nullable    = false

  validation {
    condition     = contains(["ea", "mca", "csp", "existing"], var.vending_machine)
    error_message = "vending_machine must be one of 'ea', 'mca', 'csp', or 'existing'."
  }
}

variable "vending_machine_config" {
  description = "Vending-machine-specific configuration. Shape depends on `var.vending_machine` and is validated by the selected submodule under `./modules/vending-*`."
  type        = any
  nullable    = false
}
