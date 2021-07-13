
variable "ibmcloud_api_key" {
  description = "IBMCloud API key (https://cloud.ibm.com/docs/account?topic=account-userapikey#create_user_key)"
}

variable "cluster_id" {
  description = "ROKS cluster id. Use the ROKS terraform module or other way to create it"
}

variable "on_vpc" {
  description = "Is cluster a VPC cluster"
}

variable "entitled_registry_user_email" {
  description = "Email address of the user owner of the Entitled Registry Key"
}

variable "entitled_registry_key" {
  description = "Cloud Pak Entitlement Key. Get the entitlement key from: https://myibm.ibm.com/products-services/containerlibrary"
}

variable "resource_group" {
  default     = "Default"
  description = "resource group where the cluster is running"
}

variable "config_dir" {
  default     = "./.kube/config"
  description = "directory to store the kubeconfig file"
}
