resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name            = "agentpool"
    node_count      = var.agent_count
    vm_size         = var.agent_size
    os_disk_size_gb = 30
  }

   service_principal {
     client_id     = var.aks_service_principal_app_id
     client_secret = var.aks_service_principal_client_secret
   }

  network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "kubenet"
  }

  tags = {
    Environment = "Development"
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "BlueHarvestContainer"
  resource_group_name = azurerm_resource_group.k8s.name
  location            = azurerm_resource_group.k8s.location
  sku                 = "Basic"
}

resource "azurerm_role_assignment" "acr" {
  principal_id                     = var.aks_service_principal_object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

resource "kubernetes_namespace" "namespaces" {
  for_each = var.kubernetes_namespaces

  metadata {
    name = each.key
  }

  depends_on = [azurerm_kubernetes_cluster.k8s]
}

resource "local_file" "kube_config" {
  content  = azurerm_kubernetes_cluster.k8s.kube_config_raw
  filename = ".kube/config"
}

resource "null_resource" "set-kube-config" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "az aks get-credentials -g ${azurerm_resource_group.k8s.name} -n ${azurerm_kubernetes_cluster.k8s.name} --admin --overwrite-existing"
  }
  depends_on = [local_file.kube_config]
}