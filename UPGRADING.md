# Upgrading Notes

This document captures breaking changes between versions of this module.

## Upgrading to v1.0.0

### Key Changes v1.0.0

> **⚠️ WARNING: This release replaces the root `channel`/`name`/`sku`/... variables with `vending_machine` and `vending_machine_config`, and requires Terraform `>= 1.15`. Every caller must update their module block.**

This module now provisions subscriptions through one of four submodules ("vending machines"), selected via the new `const = true` variable `var.vending_machine`: `ea`, `mca`, `csp`, or `existing`. Each vending machine declares only the providers it needs, so a caller using `existing` no longer has to configure the `restful` (CSP) provider, and a caller using `csp` no longer has to configure `azapi`.

The previous `channel = "ea"` flow was actually implemented against the Microsoft Customer Agreement (MCA) billing APIs, not Enterprise Agreement (EA). It has been split into two distinct vending machines — `ea` and `mca` — with correct, separate scoping. A genuine EA flow (`azurerm_billing_enrollment_account_scope`) is now available for the first time, and a new `existing` vending machine can adopt an already-provisioned subscription instead of creating one.

#### Minimum Terraform version raised to 1.15

The dynamic submodule selection relies on Terraform 1.15's module `source` expressions. Upgrade your Terraform CLI before upgrading this module.

```hcl
terraform {
  required_version = ">= 1.15"
}
```

#### Root variables replaced: `channel`, `name`, `sku`, `owner_id`, `billing_account_name`, `billing_profile_name`, `invoice_section_name` → `vending_machine`, `vending_machine_config`

All machine-specific inputs now live inside a single `vending_machine_config` object, whose shape depends on `vending_machine` and is validated by the selected submodule.

##### Before (`channel = "ea"`, actually MCA)

```hcl
module "subscription" {
  source = "schubergphilis-ep/mcaf-svm-csp/azure"

  channel               = "ea"
  name                  = "sub-example-prod"
  sku                   = "Production"
  owner_id              = "00000000-0000-0000-0000-000000000000"
  billing_account_name  = "1234567"
  billing_profile_name  = "AB12-CDE3-FGH4-IJK5"
  invoice_section_name  = "LM67-NOP8"
  parent_management_group_id = "/providers/Microsoft.Management/managementGroups/mg-landing-zones"
  tags = {
    environment = "production"
  }
}
```

##### After (`vending_machine = "mca"`)

```hcl
module "subscription" {
  source = "schubergphilis-ep/mcaf-svm-csp/azure"

  vending_machine = "mca"
  vending_machine_config = {
    name                  = "sub-example-prod"
    sku                   = "Production"
    owner_id              = "00000000-0000-0000-0000-000000000000"
    billing_account_name  = "1234567"
    billing_profile_name  = "AB12-CDE3-FGH4-IJK5"
    invoice_section_name  = "LM67-NOP8"
    tenant_id             = "11111111-1111-1111-1111-111111111111"
  }
  parent_management_group_id = "/providers/Microsoft.Management/managementGroups/mg-landing-zones"
  tags = {
    environment = "production"
  }
}
```

Note the new required `tenant_id` field — it was previously read implicitly from `data.azurerm_client_config.current` inside the root module. It must now be passed in explicitly.

If you actually want genuine EA billing (enrollment account scope, not MCA), set `vending_machine = "ea"` and supply `enrollment_account_name` instead of `billing_profile_name`/`invoice_section_name`:

```hcl
module "subscription" {
  source = "schubergphilis-ep/mcaf-svm-csp/azure"

  vending_machine = "ea"
  vending_machine_config = {
    name                    = "sub-example-prod"
    sku                     = "Production"
    owner_id                = "00000000-0000-0000-0000-000000000000"
    billing_account_name    = "1234567"
    enrollment_account_name = "12345"
    tenant_id               = "11111111-1111-1111-1111-111111111111"
  }
  parent_management_group_id = "/providers/Microsoft.Management/managementGroups/mg-landing-zones"
}
```

##### Before (`channel = "csp"`)

```hcl
module "subscription" {
  source = "schubergphilis-ep/mcaf-svm-csp/azure"

  channel = "csp"
  name    = "sub-example-dev"
  sku     = "DevTest"
}
```

##### After (`vending_machine = "csp"`)

```hcl
module "subscription" {
  source = "schubergphilis-ep/mcaf-svm-csp/azure"

  vending_machine = "csp"
  vending_machine_config = {
    name = "sub-example-dev"
    sku  = "DevTest"
  }
  parent_management_group_id = "/providers/Microsoft.Management/managementGroups/mg-landing-zones"
}
```

`parent_management_group_id` is now **required** for `csp` (it was previously optional and, on `main`, only actually applied for `channel = "csp"` via `azurerm_management_group_subscription_association`).

##### New: adopting an existing subscription

There was previously no way to bring an already-provisioned subscription under this module. `vending_machine = "existing"` does not create anything — it looks the subscription up and places it under the given management group:

```hcl
module "subscription" {
  source = "schubergphilis-ep/mcaf-svm-csp/azure"

  vending_machine = "existing"
  vending_machine_config = {
    subscription_id = "00000000-0000-0000-0000-000000000000"
  }
  parent_management_group_id = "/providers/Microsoft.Management/managementGroups/mg-landing-zones"
}
```

##### Migration steps

1. Determine which billing model you actually use. If you were setting `channel = "ea"`, you were using MCA — set `vending_machine = "mca"` and keep your `billing_account_name`/`billing_profile_name`/`invoice_section_name` values. Only use `vending_machine = "ea"` if you need true Enterprise Agreement billing (enrollment account scope).
2. Move `name`, `sku`, `owner_id`, and the billing-scope variables into `vending_machine_config`, matching the field names for your chosen vending machine (see the tables in `README.md`).
3. Add `tenant_id` to `vending_machine_config` for `ea`/`mca` — it is no longer inferred automatically.
4. If you were relying on `channel = "csp"` without setting `parent_management_group_id`, set it now; it is required.
5. Upgrade your Terraform CLI to `>= 1.15` before running `terraform init`.
6. Run `terraform plan` and confirm no unexpected resource replacements. The underlying resources (`azapi_resource.subscription`, `restful_operation.subscription`, `azurerm_management_group_subscription_association.this`, etc.) moved into the `vending-<name>` submodules, but this module ships `moved` blocks (see `moved.tf`) that track that refactor for you — as long as step 1 above lands you on the `vending_machine` value that matches your previous behavior, `terraform plan` should show these resources moving in place, not being destroyed and recreated. No `terraform state mv` needed. `azapi_update_resource.subscription_tags` didn't move and needs no action. See the examples under `examples/{ea,mca,csp,existing}/` for full working configurations.
