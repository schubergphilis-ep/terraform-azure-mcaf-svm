# Refactoring history: these resources previously lived at the root of this module
# (gated by `count`, keyed on the old `channel` variable) and moved into the
# vending-<name> submodules when dynamic submodule selection was introduced.
#
# `module.vending` resolves to whichever submodule the caller's `vending_machine`
# selects, and every submodule that could plausibly have owned a given resource
# declares it under the same local name (`azapi_resource.subscription`,
# `azurerm_management_group_subscription_association.this`, etc). That means each
# `moved` block below is written once and correctly resolves per-caller, based on
# whatever `vending_machine` that caller now sets.
#
# Callers must still pick the `vending_machine` value that matches their previous
# behavior (old `channel = "ea"` was actually MCA — see UPGRADING.md) for the move
# to land on the right subscription. `azapi_update_resource.subscription_tags` is
# unchanged and needs no moved block. Data sources are re-read on every plan
# regardless, so there's nothing to move for those.

moved {
  from = azapi_resource.subscription[0]
  to   = module.vending.azapi_resource.subscription
}

moved {
  from = restful_operation.subscription[0]
  to   = module.vending.restful_operation.subscription
}

moved {
  from = azurerm_management_group_subscription_association.this[0]
  to   = module.vending.azurerm_management_group_subscription_association.this
}
