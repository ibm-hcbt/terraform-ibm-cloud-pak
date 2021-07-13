// Requirements:

provider "ibm" {
  region     = "us-south"
}

data "ibm_resource_group" "group" {
  name = var.resource_group
}

data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id   = var.cluster_id
  resource_group_id = data.ibm_resource_group.group.id
  config_dir        = var.config_dir
}

// Module:
module "cp4mcm" {
  source = "../../modules/cp4mcm"
  enable = true

  // ROKS cluster parameters:
  cluster_config_path = data.ibm_container_cluster_config.cluster_config.config_file_path
  on_vpc                       = var.on_vpc

  // Entitled Registry parameters:
  entitled_registry_key        = var.entitled_registry_key
  entitled_registry_user_email = var.entitled_registry_user_email

  // MCM specific parameters
  install_infr_mgt_module      = local.install_infr_mgt_module
  install_monitoring_module    = local.install_monitoring_module
  install_security_svcs_module = local.install_security_svcs_module
  install_operations_module    = local.install_operations_module
  install_tech_prev_module     = local.install_tech_prev_module
}

// Output variables:

output "namespace" {
  value = module.cp4mcm.namespace
}
output "endpoint" {
  value = module.cp4mcm.endpoint
}
output "user" {
  value = module.cp4mcm.user
}
output "password" {
  value = module.cp4mcm.password
}

