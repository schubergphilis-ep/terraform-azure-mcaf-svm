variable "config" {
  description = <<DESCRIPTION
    Configuration for adopting an already-existing subscription.

    ```
    config = {
      subscription_id = "Id (GUID) of the existing subscription to adopt."
    }
    ```
    DESCRIPTION

  type = object({
    subscription_id = string
  })
  nullable = false
}

variable "parent_management_group_id" {
  description = "Id of the parent management group the existing subscription should be placed under."
  type        = string
  nullable    = false
}
