output "hostname" {
  value = azurerm_windows_virtual_machine.vm[0].name
}

output "fqdn" {
  value = azurerm_public_ip.pip[0].fqdn
}

output "private_ip" {
  value = azurerm_network_interface.nic[0].private_ip_address
}

output "public_ip" {
  value = azurerm_public_ip.pip[0].ip_address
}

output "vm_id" {
  value = azurerm_windows_virtual_machine.vm[0].id
}
