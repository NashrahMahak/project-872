resource "azurerm_postgresql_flexible_server" "db" {
  name                   = "psql-flex-872"
  resource_group_name    = var.rg_name
  location               = var.location
  version                = "13"
  administrator_login    = var.admin_username
  administrator_password = var.admin_password
  sku_name               = "B_Standard_B1ms"
  storage_mb             = 32768
  zone                   = "1"
  tags                   = var.tags

  lifecycle {
    ignore_changes = [zone]
  }
}
