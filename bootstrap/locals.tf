# Calculate resource names
locals {
  name_replacements = {
    workload                     = var.resource_name_workload
    environment                  = var.resource_name_environment
    location                     = var.location
    location_short               = var.resource_name_location_short == "" ? module.regions.regions_by_name[var.location].geo_code : var.resource_name_location_short
    uniqueness                   = random_string.unique_name.id
    sequence                     = format("%03d", var.resource_name_sequence_start)
    resource_name_location_short = var.resource_name_location_short
    resource_name_workload       = var.resource_name_workload
    use_runner_group             = var.use_runner_group
  }

  resource_names = { for key, value in var.resource_name_templates : key => templatestring(value, local.name_replacements) }
}

locals {
  default_audience_name = "api://AzureADTokenExchange"
  github_issuer_url     = "https://token.actions.githubusercontent.com"
}

locals {
  environments = { for key, value in var.environments : key => {
    display_order         = value.display_order
    display_name          = value.display_name
    has_approval          = value.has_approval
    dependent_environment = value.dependent_environment
    resource_group_create = value.resource_group_create
    resource_group_name = templatestring(value.resource_group_name_template, {
      workload                     = local.name_replacements.workload
      environment                  = key
      location                     = local.name_replacements.location
      sequence                     = local.name_replacements.sequence
      resource_name_location_short = local.name_replacements.resource_name_location_short
    })
    user_assigned_managed_identity_name_template = value.user_assigned_managed_identity_name_template
  } }
  environment_split_type = {
    plan  = "plan"
    apply = "apply"
  }
  environment_split = { for environment_split in flatten([for env_key, env_value in local.environments : [
    for split_key, split_value in local.environment_split_type : {
      composite_key      = "${env_key}-${split_key}"
      environment        = env_key
      type               = split_key
      required_templates = split_key == local.environment_split_type.plan ? ["ci-template.yaml", "cd-template.yaml"] : ["cd-template.yaml"]
      has_approval       = env_value.has_approval
      user_assigned_managed_identity_name = templatestring(env_value.user_assigned_managed_identity_name_template, {
        workload    = local.name_replacements.workload
        environment = env_key
        type        = split_key
        location    = local.name_replacements.location
        sequence    = local.name_replacements.sequence
      })
    }
  ]]) : environment_split.composite_key => environment_split }
}
