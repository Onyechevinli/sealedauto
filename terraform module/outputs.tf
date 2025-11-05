output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_id" {
  value = azurerm_container_registry.acr.id
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "aks_id" {
  value = azurerm_kubernetes_cluster.aks.id
}

# The managed resource group that contains AKS nodes & VMSS
output "aks_node_resource_group" {
  value = azurerm_kubernetes_cluster.aks.node_resource_group
  description = "AKS creates a managed resource group where node VMSS live. Use this to query VMSS and NSG."
}

output "public_ip_address" {
  value = azurerm_public_ip.lb_ip.ip_address
}

output "load_balancer_id" {
  value = azurerm_lb.k8s_lb.id
}

output "nsg_id" {
  value = azurerm_network_security_group.nsg.id
}
