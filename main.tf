resource "azurerm_storage_account" "this" {
  name                              = var.name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  account_replication_type          = var.account_replication_type
  account_tier                      = var.account_tier
  access_tier                       = var.access_tier
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public
  allowed_copy_scope                = var.allowed_copy_scope
  cross_tenant_replication_enabled  = var.cross_tenant_replication_enabled
  default_to_oauth_authentication   = var.default_to_oauth_authentication
  edge_zone                         = var.edge_zone
  https_traffic_only_enabled        = var.https_traffic_only_enabled
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  is_hns_enabled                    = var.is_hns_enabled
  large_file_share_enabled          = var.large_file_share_enabled
  min_tls_version                   = var.min_tls_version
  nfsv3_enabled                     = var.nfsv3_enabled
  public_network_access_enabled     = var.public_network_access_enabled
  queue_encryption_key_type         = var.queue_encryption_key_type
  sftp_enabled                      = var.sftp_enabled
  shared_access_key_enabled         = var.shared_access_key_enabled
  table_encryption_key_type         = var.table_encryption_key_type
  tags                              = var.tags

  dynamic "azure_files_authentication" {
    for_each = var.azure_files_authentication

    content {
      directory_type = azure_files_authentication.value.directory_type

      dynamic "active_directory" {
        for_each = azure_files_authentication.value.directory_type == "AD" ? { "AD" = "true" } : {}

        content {
          domain_name = active_directory.value.domain_name
          domain_guid = active_directory.value.domain_guid
          domain_sid  = active_directory.value.domain_sid
        }
      }
    }
  }

  dynamic "blob_properties" {
    for_each = var.blob_properties

    content {

      dynamic "cors_rule" {
        for_each = length(blob_properties.value.cors_rule.allowed_headers) != 0 ? { "cors_rule" = "true" } : {}

        content {
          allowed_headers    = blob_properties.value.cors_rule.allowed_headers
          allowed_methods    = blob_properties.value.cors_rule.allowed_methods
          allowed_origins    = blob_properties.value.cors_rule.allowed_origins
          exposed_headers    = blob_properties.value.cors_rule.exposed_headers
          max_age_in_seconds = blob_properties.value.cors_rule.max_age_in_seconds
        }
      }

      delete_retention_policy {
        days = blob_properties.value.delete_retention_policy.days
      }

      dynamic "restore_policy" {
        for_each = blob_properties.value.restore_policy.days != 0 ? { "restore_policy" = "true" } : {}

        content {
          days = blob_properties.value.restore_policy.days
        }

      }

      versioning_enabled            = blob_properties.value.versioning_enabled
      change_feed_enabled           = blob_properties.value.change_feed_enabled
      change_feed_retention_in_days = blob_properties.value.change_feed_retention_in_days
      default_service_version       = blob_properties.value.default_service_version
      last_access_time_enabled      = blob_properties.value.last_access_time_enabled

      container_delete_retention_policy {
        days = blob_properties.value.container_delete_retention_policy.days
      }
    }
  }

  dynamic "custom_domain" {
    for_each = var.custom_domain

    content {
      name          = custom_domain.value.name
      use_subdomain = custom_domain.value.use_subdomain
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "network_rules" {
    for_each = var.network_rules != null ? [var.network_rules] : []

    content {
      bypass                     = network_rules.value.bypass
      default_action             = network_rules.value.default_action
      ip_rules                   = network_rules.value.ip_rules
      virtual_network_subnet_ids = network_rules.value.virtual_network_subnet_ids
    }
  }

  dynamic "queue_properties" {
    for_each = var.queue_properties

    content {
      dynamic "cors_rule" {
        for_each = length(queue_properties.value.cors_rules) > 0 ? { "cors_rule" = "true" } : {}

        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "logging" {
        for_each = length(queue_properties.value.logging) != null ? { "logging" = "true" } : {}

        content {
          delete                = logging.value.delete
          read                  = logging.value.read
          version               = logging.value.version
          write                 = logging.value.write
          retention_policy_days = logging.value.retention_policy_days
        }
      }

      dynamic "minute_metrics" {
        for_each = length(queue_properties.value.minute_metrics) != null ? { "minute_metrics" = "true" } : {}

        content {
          enabled               = minute_metrics.value.enabled
          version               = minute_metrics.value.version
          include_apis          = minute_metrics.value.include_apis
          retention_policy_days = minute_metrics.value.retention_policy_days
        }
      }

      dynamic "hour_metrics" {
        for_each = length(queue_properties.value.hour_metrics) != null ? { "hour_metrics" = "true" } : {}

        content {
          enabled               = hour_metrics.value.enabled
          version               = hour_metrics.value.version
          include_apis          = hour_metrics.value.include_apis
          retention_policy_days = hour_metrics.value.retention_policy_days
        }
      }
    }
  }

  dynamic "routing" {
    for_each = var.routing

    content {
      publish_internet_endpoints  = routing.value.publish_internet_endpoints
      publish_microsoft_endpoints = routing.value.publish_microsoft_endpoints
      choice                      = routing.value.choice
    }

  }

  dynamic "share_properties" {
    for_each = var.share_properties

    content {
      dynamic "cors_rule" {
        for_each = length(share_properties.value.cors_rule.allowed_headers) != 0 ? { "cors_rule" = "true" } : {}

        content {
          allowed_headers    = share_properties.value.cors_rule.allowed_headers
          allowed_methods    = share_properties.value.cors_rule.allowed_methods
          allowed_origins    = share_properties.value.cors_rule.allowed_origins
          exposed_headers    = share_properties.value.cors_rule.exposed_headers
          max_age_in_seconds = share_properties.value.cors_rule.max_age_in_seconds
        }
      }

      retention_policy {
        days = share_properties.value.retention_policy.days
      }

      smb {
        versions                        = share_properties.value.smb.versions
        authentication_types            = share_properties.value.smb.authentication_types
        kerberos_ticket_encryption_type = share_properties.value.smb.kerberos_ticket_encryption_type
        channel_encryption_type         = share_properties.value.smb.channel_encryption_type
        multichannel_enabled            = share_properties.value.smb.multichannel_enabled
      }
    }
  }

  dynamic "static_website" {
    for_each = var.static_website

    content {
      index_document     = static_website.value.index_document
      error_404_document = static_website.value.error_404_document
    }
  }

  # Sleep to allow ARM changes to be propagated
  provisioner "local-exec" {
    command = "sleep 60"
  }
}

resource "azurerm_storage_container" "this" {
  for_each = var.containers

  name                  = each.value.name
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = each.value.container_access_type
}

resource "azurerm_storage_share" "this" {
  for_each = var.file_share

  name                 = each.value.name
  storage_account_name = azurerm_storage_account.this.name
  quota                = each.value.quota
}

resource "azurerm_storage_queue" "this" {
  for_each = var.queues

  name                 = each.value.name
  storage_account_name = azurerm_storage_account.this.name
}

resource "azurerm_storage_table" "this" {
  for_each = var.tables

  name                 = each.value.name
  storage_account_name = azurerm_storage_account.this.name

  dynamic "acl" {
    for_each = each.value.acl

    content {
      id = acl.value.id
      access_policy {
        expiry      = acl.value.access_policy.expiry
        permissions = acl.value.access_policy.permissions
        start       = acl.value.access_policy.start
      }
    }
  }
}

resource "azurerm_private_endpoint" "blob" {
  for_each = var.blob_private_endpoint

  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = var.resource_group_name
  subnet_id                     = each.value.subnet_id
  custom_network_interface_name = each.value.custom_network_interface_name

  private_service_connection {
    name                           = each.value.private_service_connection_name
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["Blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "privatelink.blob.core.windows.net"
    private_dns_zone_ids = each.value.private_dns_zone_ids
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "file" {
  for_each = var.file_private_endpoint

  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = var.resource_group_name
  subnet_id                     = each.value.subnet_id
  custom_network_interface_name = each.value.custom_network_interface_name

  private_service_connection {
    name                           = each.value.private_service_connection_name
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "privatelink.file.core.windows.net"
    private_dns_zone_ids = each.value.private_dns_zone_ids
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "table" {
  for_each = var.table_private_endpoint

  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = var.resource_group_name
  subnet_id                     = each.value.subnet_id
  custom_network_interface_name = each.value.custom_network_interface_name

  private_service_connection {
    name                           = each.value.private_service_connection_name
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "privatelink.table.core.windows.net"
    private_dns_zone_ids = each.value.private_dns_zone_ids
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "queue" {
  for_each = var.queue_private_endpoint

  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = var.resource_group_name
  subnet_id                     = each.value.subnet_id
  custom_network_interface_name = each.value.custom_network_interface_name

  private_service_connection {
    name                           = each.value.private_service_connection_name
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "privatelink.queue.core.windows.net"
    private_dns_zone_ids = each.value.private_dns_zone_ids
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "web" {
  for_each = var.web_private_endpoint

  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = var.resource_group_name
  subnet_id                     = each.value.subnet_id
  custom_network_interface_name = each.value.custom_network_interface_name

  private_service_connection {
    name                           = each.value.private_service_connection_name
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["web"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "privatelink.web.core.windows.net"
    private_dns_zone_ids = each.value.private_dns_zone_ids
  }

  tags = var.tags
}

module "diagnostics" {
  for_each = var.diagnostic_settings

  source = "heathen1878/diagnostic-logging/azurerm"
  version = "1.0.0"

  name                           = each.value.name
  target_resource_id             = format("%s/%s", azurerm_storage_account.this.id, each.value.target_sub_resource)
  eventhub_name                  = each.value.eventhub_name
  eventhub_authorization_rule_id = each.value.eventhub_authorization_rule_id
  log_analytics_workspace_id     = each.value.log_analytics_workspace_id
  log_analytics_destination_type = each.value.log_analytics_destination_type
  logs                           = each.value.logs
  log_category                   = each.value.log_category
  metrics                        = each.value.metrics
  storage_account_id             = each.value.storage_account_id
}