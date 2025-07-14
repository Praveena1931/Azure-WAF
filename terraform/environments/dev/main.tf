provider "azurerm" {
  features {}
}

module "WAF" {
  source                    = "../../modules/waf"
  resource_group_name = var.resource_group_name
  resource_group_location = var.location
  virtual_network_name =  var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  subnet_name                 = var.subnet_name
  address_prefixes     = ["10.0.1.0/24"]
  name                = "waf-pip"
  allocation_method   = "Static"
  sku                 = "Standard"
  gateway_name        = "example-waf"
  gatewayconfig_name      = "gwipconfig"
  subnet_id = azurerm_subnet.subnet.id

# resource "azurerm_resource_group" "rg" {
#   name     = var.resource_group_name
#   location = var.location
# }

# resource "azurerm_virtual_network" "vnet" {
#   name                = var.vnet_name
#   address_space       = ["10.0.0.0/16"]
#   location            = var.location
#   resource_group_name = azurerm_resource_group.rg.name
# }

# resource "azurerm_subnet" "subnet" {
#   name                 = var.subnet_name
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = ["10.0.1.0/24"]
# }

# resource "azurerm_public_ip" "pip" {
#   name                = "waf-pip"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.rg.name
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

resource "azurerm_application_gateway" "waf" {
  name                = "example-waf"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "gwipconfig"
    subnet_id = azurerm_subnet.subnet.id
  }

  frontend_port {
    name = "frontendPort"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontendIP"
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  backend_address_pool {
    name = "backendPool"
  }

  backend_http_settings {
    name                  = "httpSettings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
  }

  http_listener {
    name                           = "httpListener"
    frontend_ip_configuration_name = "frontendIP"
    frontend_port_name             = "frontendPort"
    protocol                       = "Http"
  }

  url_path_map {
    name                               = "urlPathMap"
    default_backend_address_pool_name  = "backendPool"
    default_backend_http_settings_name = "httpSettings"

    path_rule {
    name                       = "example-path-rule"
    paths                      = ["/images/*", "/videos/*"]
    backend_address_pool_name  = "backendPool"
    backend_http_settings_name = "httpSettings"
  }
  }

  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    http_listener_name         = "httpListener"
    backend_address_pool_name  = "backendPool"
    backend_http_settings_name = "httpSettings"
    priority = 100
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }
}
