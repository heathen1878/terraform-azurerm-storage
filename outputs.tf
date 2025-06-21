output "container" {
  description = "Storage containers"
  value       = azurerm_storage_container.this
}

output "queue" {
  description = "Storage queues"
  value       = azurerm_storage_queue.this
}

output "share" {
  description = "Storage shares"
  value       = azurerm_storage_share.this
}

output "account" {
  description = "Storage accounts"
  value       = azurerm_storage_account.this
  sensitive   = true
}

output "table" {
  description = "Storage tables"
  value       = azurerm_storage_table.this
}