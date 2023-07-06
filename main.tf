resource "azurerm_storage_account" "storage_account" {
  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  account_replication_type        = var.account_replication_type
  account_tier                    = var.account_tier
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  allowed_copy_scope              = var.allowed_copy_scope

  # TODO: Implement this block
  #dynamic "azure_files_authentication" {
  #  for_each = length(var.azure_files_authentication) != 0 ? { "azure_files_auth" = "enabled" } : {}

  #  content {
  #    directory_type = azure_files_authentication.directory_type
  #  }
  #}

  # TODO: Implement this block
  #blob_properties {
  #var.blob_properties
  #}

  cross_tenant_replication_enabled = var.cross_tenant_replication_enabled

  # TODO: Implement this block
  #custom_domain {
  #var.custom_domain
  #}

  # TODO: Implement this block
  #customer_managed_key {
  #var.customer_managed_key
  #}

  default_to_oauth_authentication = var.default_to_oauth_authentication
  edge_zone                       = var.edge_zone
  enable_https_traffic_only       = var.enable_https_traffic_only

  identity {
    type         = var.identity.type
    identity_ids = var.identity.identity_ids
  }

  # TODO: Implement this block
  #dynamic "immutability_policy" {
  #  for_each = length(var.immutability_policy) != 0 ? { "azure_files_auth" = "enabled" } : {}

  #  content {
  #    allow_protected_append_writes = immutability_policy.allow_protected_append_writes
  #    state                         = immutability_policy.state
  #    period_since_creation_in_days = immutability_policy.period_since_creation_in_days
  #  }
  #}

  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  is_hns_enabled                    = var.is_hns_enabled
  large_file_share_enabled          = var.large_file_share_enabled
  min_tls_version                   = var.min_tls_version

  network_rules {
    bypass                     = var.network_rules.bypass
    default_action             = var.network_rules.default_action
    ip_rules                   = var.network_rules.ip_rules
    virtual_network_subnet_ids = var.network_rules.virtual_network_subnet_ids
  }

  nfsv3_enabled                 = var.nfsv3_enabled
  public_network_access_enabled = var.public_network_access_enabled
  queue_encryption_key_type     = var.queue_encryption_key_type

  # TODO: Implement this block
  #queue_properties {
  #}

  # TODO: Implement this block
  #routing {
  #}

  # TODO: Implement this block
  #sas_policy {
  #}

  sftp_enabled = var.sftp_enabled

  # TODO: Implement this block
  #share_properies {}

  shared_access_key_enabled = var.shared_access_key_enabled

  # TODO: Implement this block
  #static_website {
  #}

  table_encryption_key_type = var.table_encryption_key_type

  tags = var.tags

}

resource "azurerm_storage_container" "storage_account" {
  for_each = var.containers

  name                  = each.value.name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = each.value.container_access_type
}

resource "azurerm_private_endpoint" "storage_account" {
  for_each = var.enable_private_endpoint == true ? { "Private Endpoint" = "True" } : {}

  name                          = format("pep-%s", var.name)
  location                      = var.location
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.virtual_network_subnet_private_endpoint_id
  custom_network_interface_name = format("nic-%s", var.name)

  private_service_connection {
    name                           = format("pl-%s", var.name)
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    subresource_names              = ["Blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "privatelink.blob.core.windows.net"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "storage_account" {
  for_each = var.iam

  scope                = azurerm_storage_account.storage_account.id
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}

resource "azurerm_role_assignment" "storage_container" {
  for_each = var.container_iam

  scope                = azurerm_storage_container.storage_account[each.value.container].resource_manager_id
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}