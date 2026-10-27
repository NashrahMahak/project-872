resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-ccgc5502-872"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_recovery_services_vault" "rsv" {
  name                = "rv-ccgc5502-872"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_storage_account" "sa" {
  name                     = "sa872commonstore"
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}
