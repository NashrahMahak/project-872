resource "null_resource" "display_hostnames" {
  for_each = local.linux_vms

  provisioner "remote-exec" {
    inline = [
      "hostname"
    ]

    connection {
      type     = "ssh"
      user     = var.admin_username
      password = var.admin_password
      host     = azurerm_public_ip.pip[each.key].ip_address
    }
  }

  depends_on = [azurerm_linux_virtual_machine.vm]
}
