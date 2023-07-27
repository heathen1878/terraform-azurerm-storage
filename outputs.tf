output "storage_account" {
  value = {
    id                    = azurerm_storage_account.storage_account.id
    primary_blob_endpoint = azurerm_storage_account.storage_account.primary_blob_endpoint
    primary_access_key    = azurerm_storage_account.storage_account.primary_access_key
  }
  sensitive = true
}