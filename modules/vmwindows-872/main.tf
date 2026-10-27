resource "azurerm_availability_set" "avset" {
  name                         = "872-windows-avset"
  location                     = var.location
  resource_group_name          = var.rg_name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5
  tags                         = var.tags
}

resource "azurerm_public_ip" "pip" {
  count               = 1
  name                = "pip-windows-${count.index + 1}-872"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "dns-win-${count.index + 1}-872"
  tags                = var.tags
}

resource "azurerm_network_interface" "nic" {
  count               = 1
  name                = "nic-windows-${count.index + 1}-872"
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  count               = 1
  name                = "872-win-vm"
  resource_group_name = var.rg_name
  location            = var.location
  size                = "Standard_B2s"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  availability_set_id = azurerm_availability_set.avset.id
  tags                = var.tags

  network_interface_ids = [azurerm_network_interface.nic[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = var.sa_blob_endpoint
  }
}

resource "azurerm_virtual_machine_extension" "antimalware" {
  count                      = 1
  name                       = "IaaSAntimalware"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm[count.index].id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "1.5"
  auto_upgrade_minor_version = true
}
