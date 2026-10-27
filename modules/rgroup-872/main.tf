resource "azurerm_resource_group" "rg" {
  name     = "872-RG"
  location = var.location
  tags     = var.tags
}
