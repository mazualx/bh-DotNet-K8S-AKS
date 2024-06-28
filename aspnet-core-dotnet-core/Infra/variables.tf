variable "resource_group_location" {
  default = "NorthEurope"
}

variable "agent_count" {
  default = 1
}

variable "agent_size" {
  default = "Standard_D2_v2"
}

variable "dns_prefix" {
  default = "k8s"
}

variable "cluster_name" {
  default = "k8s"
}

variable "kubernetes_namespaces" {
  description = "The namespaces that will be created with the deployment of the AKS"
  type        = set(string)
}

variable "aks_service_principal_app_id" {
  #default = Add your AppId here
}

variable "aks_service_principal_object_id" {
  #default = #Add your Principal Id here
}

variable "aks_service_principal_client_secret" {
  #default = #Add your Client secret here
}