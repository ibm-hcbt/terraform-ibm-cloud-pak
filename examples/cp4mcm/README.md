# Example to provision IAF Terraform Module

## Run using IBM Cloud Schematics

For instructions to run these examples using IBM Schematics go [here](../Using_Schematics.md)

For more information on IBM Schematics, refer [here](https://cloud.ibm.com/docs/schematics?topic=schematics-get-started-terraform).

## Run using local Terraform Client

For instructions to run using the local Terraform Client on your local machine go [here](../Using_Terraform.md)
setting these values in the `terraform.tfvars` file:

```hcl
ibmcloud_api_key             = "**********************"
cluster_id                   = "<cluster_id>"
on_vpc                       = true
resource_group               = "<resource_group>"
entitled_registry_user_email = "John.Smith@ibm.com"
entitled_registry_key        = "**********************"
```

These parameters are:

- `ibmcloud_api_key`: IBM Cloud API Key. Refer to https://cloud.ibm.com/docs/account?topic=account-userapikey#create_user_key for info on how to create one
- `on_vpc`: What infrastructure is the cluster provisioned with. The possible values are: `true` (VPC) and `false` (Classic). The default value and only supported at this time is `false`.
- `cluster_id`: Cluster ID of the OpenShift cluster where to install CP4MCM
- `resource_group`: Resource group where the cluster is running. Default value is `Default`
- `entitled_registry_user_email`: username or email address of the user owner of the entitlement key. There is no default value, so this variable is required.
- `entitled_registry_key`: Cloud Pak entitlement key (retrieved from https://myibm.ibm.com/products-services/containerlibrary). There is no default value, so this variable is required.

### Executing the Example

Execute the following Terraform commands:

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

## Verify

To verify installation on the Kubernetes cluster you need `kubectl`, then execute:

```bash
export KUBECONFIG=$(terraform output config_file_path)

kubectl cluster-info

# Namespace
kubectl get namespaces $(terraform output namespace)

# Secret
kubectl get secrets -n $(terraform output namespace) ibm-management-pull-secret -o yaml

# CatalogSource
kubectl -n openshift-marketplace get catalogsource
kubectl -n openshift-marketplace get catalogsource ibm-management-orchestrator
kubectl -n openshift-marketplace get catalogsource opencloud-operators

# Subscription
kubectl -n openshift-operators get subscription ibm-common-service-operator-stable-v1-opencloud-operators-openshift-marketplace ibm-management-orchestrator operand-deployment-lifecycle-manager-app

# Ingress
kubectl -n openshift-ingress get route router-default

# Installation
kubectl -n $(terraform output namespace) get installations.orchestrator.management.ibm.com ibm-management
```

To test MCM console use the address from the `endpoint` output parameter with the `user` and `password` output parameters as credentials.

```bash
terraform output user
terraform output password

open "https://$(terraform output endpoint)"
```

or

```bash
# URL to MCM Console
kubectl -n ibm-common-services get route cp-console  -o jsonpath='{.spec.host}'

# MCM Credentials
# User:
kubectl -n ibm-common-services get secret platform-auth-idp-credentials -o jsonpath='{.data.admin_username}' | base64 -d
# Password:
kubectl -n ibm-common-services get secret platform-auth-idp-credentials -o jsonpath='{.data.admin_password}' | base64 -d
```

## Cleanup

To remove all resources created by this module execute: `terraform destroy`.

There are some directories and files you may want to manually delete, these are: `rm -rf terraform.tfstate* .terraform .kube`
