output "waf_public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "application_gateway_id" {
  value = azurerm_application_gateway.waf.id
}
