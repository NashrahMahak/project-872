output "law_name" {
  value = azurerm_log_analytics_workspace.law.name
}

output "rsv_name" {
  value = azurerm_recovery_services_vault.rsv.name
}

output "sa_name" {
  value = azurerm_storage_account.sa.name
}

output "sa_primary_blob_endpoint" {
  value = azurerm_storage_account.sa.primary_blob_endpoint
}
