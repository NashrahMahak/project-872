locals {
  linux_vms = {
    "vm1" = { zone = "1", name = "872-linux-vm1" }
    "vm2" = { zone = "2", name = "872-linux-vm2" }
    "vm3" = { zone = "3", name = "872-linux-vm3" }
  }
}

resource "azurerm_public_ip" "pip" {
  for_each            = local.linux_vms
  name                = "pip-linux-${each.key}-872"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "dns-linux-${each.key}-872"
  tags                = var.tags
}

resource "azurerm_network_interface" "nic" {
  for_each            = local.linux_vms
  name                = "nic-linux-${each.key}-872"
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[each.key].id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = local.linux_vms
  name                            = each.value.name
  resource_group_name             = var.rg_name
  location                        = var.location
  size                            = "Standard_B1s"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  zone                            = each.value.zone
  tags                            = var.tags

  network_interface_ids = [azurerm_network_interface.nic[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = var.sa_blob_endpoint
  }
}

resource "azurerm_virtual_machine_extension" "network_watcher" {
  for_each                   = local.linux_vms
  name                       = "NetworkWatcherAgentLinux"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm[each.key].id
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentLinux"
  type_handler_version       = "1.4"
  auto_upgrade_minor_version = true
}

resource "azurerm_virtual_machine_extension" "azure_monitor" {
  for_each                   = local.linux_vms
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm[each.key].id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}
