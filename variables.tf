variable "name" {
  description = "Storage Account Name"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.name))
    error_message = "The storage account name must be lowercase and between 3 and 24 characters in length"
  }
}

variable "location" {
  description = "Key Vault location"
  type        = string
  validation {
    condition     = can(regex("^[a-z]+(?:[23])?$", var.location))
    error_message = "The location must be a lowercase and constructed using letters a-z; can have an optional number appended too."
  }
}

variable "resource_group_name" {
  description = "Storage Account Resource Group"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9._()\\-]*[^.]$", var.resource_group_name))
    error_message = "The resource group name must start with a number or letter, and can consist of letters, numbers, underscores, periods, parentheses and hyphens but must not end in a period."
  }
}

variable "account_kind" {
  description = "The storage account kind"
  default     = "StorageV2"
  type        = string
  validation {
    condition = contains(
      [
        "StorageV2",
        "Storage",
        "FileStorage",
        "BlockBlobStorage",
        "BlobStorage"
      ], var.account_kind
    )
    error_message = "Account kind valid options are: StorageV2, Storage, FileStorage, BlockBlobStorage, or BlobStorage"
  }
}

variable "account_tier" {
  description = "The storage account tier"
  default     = "Standard"
  type        = string
  validation {
    condition     = (contains(["BlockBlobStorage", "FileStorage"], var.account_kind) && var.account_tier == "Premium") || contains(["Standard", "Premium"], var.account_tier)
    error_message = "Account tier can be Standard or Premium but must be Premium if Account Kind is BlockBlobStorage or FileStorage"
  }
}

variable "account_replication_type" {
  description = "The storage account replication"
  default     = "ZRS"
  type        = string
  validation {
    condition = contains([
      "LRS",
      "ZRS",
      "GRS",
      "RAGRS",
      "GZRS",
      "RAGZRS"
    ], var.account_replication_type)
    error_message = "The replication type must be one of LRS, ZRS, GRS, RAGRS or GZRS, RAGZRS"
  }
}

variable "access_tier" {
  description = "The storage account access tier - Hot or Cool"
  default     = "Hot"
  type        = string
  validation {
    condition     = contains(["Hot", "Cool"], var.access_tier)
    error_message = "This is only valid if the account kind is BlobStorage, FileStorage or StorageV2"
  }
}

variable "allow_nested_items_to_be_public" {
  description = "Allow nested items to be public?"
  default     = "false"
  type        = string
  validation {
    condition     = contains(["true", "false"], var.allow_nested_items_to_be_public)
    error_message = "Can only be set to True or False as a string."
  }
}

variable "allowed_copy_scope" {
  description = "Restrict copy to and from the storage account within a AAD tenant or Private Link vNet"
  default     = null
  type        = string
  # validation {

  # }
}

variable "azure_files_authentication" {
  description = "AADDS, AD or AADKERB"
  default     = {}
  type = map(object({
    directory_type = optional(string)
    active_directory = optional(object({
      storage_sid         = optional(string)
      domain_name         = optional(string)
      domain_sid          = optional(string)
      domain_guid         = optional(string)
      forest_name         = optional(string)
      netbios_domain_name = optional(string)
    }), {})
  }))
}

variable "blob_private_endpoint" {
  description = "Enable private blob endpoint for Storage Account?"
  default     = {}
  type = map(object(
    {
      name                            = string
      location                        = string
      resource_group_name             = string
      subnet_id                       = string
      custom_network_interface_name   = string
      private_service_connection_name = string
      private_dns_zone_ids            = list(string)
    }
  ))
}

variable "blob_properties" {
  description = "A map of blob properties"
  default = {
    defaults = {}
  }
  type = map(object(
    {
      cors_rule = optional(object(
        {
          allowed_headers    = optional(list(string), [])
          allowed_methods    = optional(list(string), [])
          allowed_origins    = optional(list(string), [])
          exposed_headers    = optional(list(string), [])
          max_age_in_seconds = optional(number, 30)
        }
      ), {})
      delete_retention_policy = optional(object(
        {
          days = optional(number, 30)
        }
      ), {})
      restore_policy = optional(object(
        {
          days = optional(number, 0)
        }
      ), {})
      versioning_enabled            = optional(bool, true)
      change_feed_enabled           = optional(bool, false)
      change_feed_retention_in_days = optional(number, null)
      default_service_version       = optional(string, null)
      last_access_time_enabled      = optional(bool, false)
      container_delete_retention_policy = optional(object(
        {
          days = optional(number, 30)
        }
      ), {})
    }
  ))
}

variable "cross_tenant_replication_enabled" {
  description = "Should cross Tenant replication be enabled?"
  default     = true
  type        = bool
}

variable "containers" {
  description = "A map of containers to create"
  default     = {}
  type = map(object({
    container_access_type = optional(string, "private")
    name                  = optional(string)
  }))
}

variable "custom_domain" {
  description = "A custom domain for the storage account"
  default     = {}
  type = map(object(
    {
      name          = optional(string, null)
      use_subdomain = optional(bool, true)
    }
  ))
}

variable "default_to_oauth_authentication" {
  description = "Use AAD for storage account access within the portal"
  default     = false
  type        = bool
}

variable "diagnostic_settings" {
  description = "A map of objects with diagnostic configuration"
  default     = {}
  type = map(object({
    name                           = string
    target_sub_resource            = string
    eventhub_name                  = optional(string)
    eventhub_authorization_rule_id = optional(string)
    log_analytics_workspace_id     = optional(string)
    log_analytics_destination_type = optional(string)
    logs                           = optional(list(string))
    log_category                   = optional(list(string))
    metrics                        = optional(list(string))
    storage_account_id             = optional(string)
  }))
}

variable "edge_zone" {
  description = "The edge zone within the Azure region where this storage account should reside"
  default     = null
  type        = string
}

variable "https_traffic_only_enabled" {
  description = "Force HTTPS?"
  default     = true
  type        = bool
}

variable "file_private_endpoint" {
  description = "Enable private file endpoint for Storage Account?"
  default     = {}
  type = map(object(
    {
      name                            = string
      location                        = string
      resource_group_name             = string
      subnet_id                       = string
      custom_network_interface_name   = string
      private_service_connection_name = string
      private_dns_zone_ids            = list(string)
    }
  ))
}

variable "file_share" {
  description = "A map of file shares"
  default     = {}
  type = map(object(
    {
      name  = string
      quota = optional(number, 1)
    }
  ))
}

variable "identity" {
  description = "Create a Managed Identity?"
  default     = null
  type = object(
    {
      identity_ids = optional(list(string), [])
      type         = string
    }
  )
}

variable "infrastructure_encryption_enabled" {
  description = "Enable infrastructure encryption?"
  default     = true
  type        = bool
}

variable "is_hns_enabled" {
  description = "Enable hierarchical namespace support?"
  default     = false
  type        = bool
}

variable "large_file_share_enabled" {
  description = "Enable large file shares?"
  default     = false
  type        = bool
}

variable "min_tls_version" {
  description = "The minimum version of TLS the storage account will accept"
  default     = "TLS1_2"
  type        = string
}

variable "network_rules" {
  description = "Network rules to assign to the storage account"
  default     = null
  type = object({
    bypass = optional(list(string), [
      "AzureServices"
      ]
    )
    default_action             = optional(string, "Allow")
    ip_rules                   = optional(list(string), [])
    private_link_access        = optional(object({}), {})
    virtual_network_subnet_ids = optional(list(string), [])
  })
}

variable "nfsv3_enabled" {
  description = "Enable NFS protcol?"
  default     = false
  type        = bool
}

variable "queue_private_endpoint" {
  description = "Enable private queue endpoint for Storage Account?"
  default     = {}
  type = map(object(
    {
      name                            = string
      location                        = string
      resource_group_name             = string
      subnet_id                       = string
      custom_network_interface_name   = string
      private_service_connection_name = string
      private_dns_zone_ids            = list(string)
    }
  ))
}

variable "table_private_endpoint" {
  description = "Enable private table endpoint for Storage Account?"
  default     = {}
  type = map(object(
    {
      name                            = string
      location                        = string
      resource_group_name             = string
      subnet_id                       = string
      custom_network_interface_name   = string
      private_service_connection_name = string
      private_dns_zone_ids            = list(string)
    }
  ))
}

variable "public_network_access_enabled" {
  description = "Enable public network access?"
  default     = true
  type        = bool
}

variable "queue_encryption_key_type" {
  description = "Service or Account encryption?"
  default     = "Service"
  type        = string
}

variable "queue_properties" {
  description = "Queue properties"
  default     = {}
  type = map(object(
    {
      cors_rules = optional(object(
        {
          allowed_headers    = optional(list(string), [])
          allowed_methods    = optional(list(string), [])
          allowed_origins    = optional(list(string), [])
          exposed_headers    = optional(list(string), [])
          max_age_in_seconds = optional(number, 30)
        }
      ), {})
      logging = optional(object(
        {
          delete                = string
          read                  = string
          version               = string
          write                 = string
          retention_policy_days = optional(number)
        }
      ), null)
      minute_metrics = optional(object(
        {
          enabled               = bool
          version               = string
          include_apis          = optional(bool, false)
          retention_policy_days = optional(number)
        }
      ), null)
      hour_metrics = optional(object(
        {
          enabled               = bool
          version               = string
          include_apis          = optional(bool, false)
          retention_policy_days = optional(number)
        }
      ), null)
    }
  ))
}

variable "queues" {
  description = "A map of queues to create"
  default     = {}
  type = map(object(
    {
      name = optional(string)
    }
  ))
}

variable "routing" {
  description = "Storage network routing"
  default = {
    default = {
      publish_internet_endpoints  = false
      publish_microsoft_endpoints = false
      choice                      = "MicrosoftRouting"
    }
  }
  type = map(object(
    {
      publish_internet_endpoints  = optional(bool, false)
      publish_microsoft_endpoints = optional(bool, false)
      choice                      = optional(string, "MicrosoftRouting")
    }
  ))
}

variable "sftp_enabled" {
  description = "Should SFTP be enabled? - is_hns_enabled must be true"
  default     = false
  type        = bool
}

variable "share_properties" {
  description = "Share properties"
  default     = {}
  type = map(object(
    {
      cors_rules = optional(object(
        {
          allowed_headers    = optional(list(string), [])
          allowed_methods    = optional(list(string), [])
          allowed_origins    = optional(list(string), [])
          exposed_headers    = optional(list(string), [])
          max_age_in_seconds = optional(number, 30)
        }
      ), {})
      retention_policy = optional(object(
        {
          days = optional(number, 7)
        }
      ), {})
      # Maximum Security
      smb = optional(object(
        {
          versions = optional(list(string), [
            "SMB3.1.1"
            ]
          )
          authentication_types = optional(list(string), [
            "Kerberos"
            ]
          )
          kerberos_ticket_encryption_type = optional(list(string), [
            "AES-256"
            ]
          )
          channel_encryption_type = optional(list(string), [
            "AES-256-GCM"
            ]
          )
          multichannel_enabled = optional(bool, false)
        }
      ), {})
    }
  ))
}

variable "shared_access_key_enabled" {
  description = "Can the storage acount be accessed using the shared key?"
  default     = true
  type        = bool
}

variable "static_website" {
  description = "Static website configuration within the storage account"
  default     = {}
  type = map(object(
    {
      index_document     = optional(string, "index.html")
      error_404_document = optional(string, "404.html")
    }
  ))
}

variable "tables" {
  description = "A map of table storage to create"
  default     = {}
  type = map(object(
    {
      name = string
      acl = optional(map(object(
        {
          id = optional(string, null)
          access_policy = optional(object(
            {
              expiry      = optional(string, null)
              permissions = optional(string, null)
              start       = optional(string, null)
            }
          ))
        }
      )), {})
    }
  ))
}

variable "table_encryption_key_type" {
  description = "Service or Account encryption?"
  default     = "Service"
  type        = string
}

variable "tags" {
  description = "A map of tags"
  type        = map(any)
  validation {
    condition     = alltrue([for v in values(var.tags) : can(regex(".*", v))])
    error_message = "All values in the map must be strings"
  }
}

variable "web_private_endpoint" {
  description = "Enable private static website endpoint for Storage Account?"
  default     = {}
  type = map(object(
    {
      name                            = string
      location                        = string
      resource_group_name             = string
      subnet_id                       = string
      custom_network_interface_name   = string
      private_service_connection_name = string
      private_dns_zone_ids            = list(string)
    }
  ))
}