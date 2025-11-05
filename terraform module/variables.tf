variable "location" {
  type    = string
  default = "eastus"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to create"
  default     = "sealedauto"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "acr_name" {
  type        = string
  description = "Name of the Azure Container Registry"
  default     = "sealedautoacr"
}

variable "aks_name" {
  type        = string
  description = "Name of the AKS cluster"
  default     = "sealedauto-aks"
}

variable "dns_prefix" {
  type    = string
  default = "sealedauto"
}

variable "node_count" {
  type    = number
  default = 1
}

variable "node_vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "vnet_name" {
  type    = string
  default = "aks-vnet"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "subnet_name" {
  type    = string
  default = "aks-subnet"
}

variable "subnet_prefix" {
  type    = string
  default = "10.0.0.0/24"
}

variable "public_ip_name" {
  type    = string
  default = "sealedauto-publicip"
}

variable "public_ip_allocation" {
  type    = string
  default = "Static" # Standard SKU requires Static
}

variable "public_ip_sku" {
  type    = string
  default = "Standard"
}
