location                     = "westeurope"
resource_name_location_short = "weu"
organization_name            = "BCP"
# You can omit this is you don't want to demo approvals on the production environment. Remove this whole approvers block to omit.
approvers = {
  user1 = "david.deklerk@prorail.nl"
  user2 = "frans.koster@prorail.nl"
}
use_self_hosted_agents = true
use_runner_group       = true
#self_hosted_agent_type = "azure_container_app"

#testprorail
#resource_name_workload = "ghe"

#prorail
resource_name_workload = "ghep"
