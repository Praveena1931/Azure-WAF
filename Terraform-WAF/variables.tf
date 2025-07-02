variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default = "waf-rg"
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "East US"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default = "waf-vnet"
}

variable "subnet_name" {
  description = "Name of the subnet for Application Gateway"
  type        = string
  default = "waf-subnet"
}
