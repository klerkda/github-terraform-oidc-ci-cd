location          = "westeurope"
organization_name = "bcp"

# For prorail domain
resource_name_workload = "ghep"

# You can omit this is you don't want to demo approvals on the production environment. Remove this whole approvers block to omit.
approvers = {
  user1 = "david.deklerk@prorail.nl",
  user2 = "frans.koster@prorail.nl"
}
