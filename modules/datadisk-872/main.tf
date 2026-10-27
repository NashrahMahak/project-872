locals {
  all_vm_ids = concat(var.linux_vm_ids, [var.windows_vm_id])
}

resource "azurerm_managed_disk" "disk" {
  count                = 4
  name                 = "datadisk-872-${count.index + 1}"
  location             = var.location
  resource_group_name  = var.rg_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
  zone                 = count.index < 3 ? tostring(count.index + 1) : null
  tags                 = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "attach" {
  count              = 4
  managed_disk_id    = azurerm_managed_disk.disk[count.index].id
  virtual_machine_id = local.all_vm_ids[count.index]
  lun                = count.index
  caching            = "ReadWrite"
}
