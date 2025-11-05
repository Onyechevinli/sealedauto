# Resource Group (created if not existing)
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# ACR
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = var.tags
}

# Virtual network + subnet
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_prefix]
}

# Network Security Group (user-specified name can be passed)
resource "azurerm_network_security_group" "nsg" {
  name                = "aks-agentpool-213-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

# Associate NSG to subnet
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.aks_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Public IP for LoadBalancer (Standard SKU recommended for AKS)
resource "azurerm_public_ip" "lb_ip" {
  name                = var.public_ip_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = var.public_ip_allocation
  sku                 = var.public_ip_sku
  tags                = var.tags
}

# AKS cluster using system-assigned managed identity
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "nodepool"
    node_count = var.node_count
    vm_size    = var.node_vm_size
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
    type = "VirtualMachineScaleSets"
  }

  identity {
    type = "SystemAssigned"
  }


  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }

  tags = var.tags
}

# Grant AKS's managed identity AcrPull role on ACR so AKS can pull images
data "azurerm_client_config" "current" {}

# AKS cluster principal id (system assigned)
locals {
  aks_sp_object_id = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = local.aks_sp_object_id
}

# (Optional) Create Azure Load Balancer resource that you can use if you
# want to create static in-cluster LoadBalancer or reference it (AKS usually
# manages its own LBs for Services of type LoadBalancer).
resource "azurerm_lb" "k8s_lb" {
  name                = "kubernetes"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_ip.id
  }
  tags = var.tags
}
