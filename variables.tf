variable "name" {
  description = "Key Vault Name"
  type        = string
}

variable "location" {
  description = "Key Vault location"
  type        = string
}

variable "resource_group_name" {
  description = "Key Vault ressource group"
  type        = string
}

variable "access_tier" {
  description = "The storage account access tier - Hot or Cool"
  default     = "Hot"
  type        = string
}

variable "account_kind" {
  description = "The storage account kind"
  default     = "StorageV2"
  type        = string
}

variable "account_replication_type" {
  description = "The storage account replication"
  type        = string
}

variable "account_tier" {
  description = "The storage account tier"
  type        = string
}

variable "allow_nested_items_to_be_public" {
  description = "Allow nested items to be public?"
  default     = "false"
  type        = string
}

variable "allowed_copy_scope" {
  description = "Restrict copy to and from the storage account within a AAD tenant or Private Link vNet"
  default     = null
  type        = string
}

variable "azure_files_authentication" {
  description = "AADDS, AD or AADKERB"
  default     = {}
  type = object({
    directory_type = optional(string)
    active_directory = optional(object({
      storage_sid         = optional(string)
      domain_name         = optional(string)
      domain_sid          = optional(string)
      domain_guid         = optional(string)
      forest_name         = optional(string)
      netbios_domain_name = optional(string)
    }), {})
  })
}

variable "blob_properties" {
  description = "A map of blob properties"
  default     = {}
  type        = map(any)
}

variable "cross_tenant_replication_enabled" {
  description = "Should cross Tenant replication be enabled?"
  default     = true
  type        = bool
}

variable "container_iam" {
  description = "A map of container IAM assignments"
  type = map(object({
    container            = optional(string)
    principal_id         = optional(string)
    role_definition_name = optional(string)
  }))
}

variable "containers" {
  description = "A map of containers to create"
  default     = {}
  type = map(object({
    container_access_type = optional(string)
    name                  = optional(string)
  }))
}

variable "custom_domain" {
  description = "A custom domain for the storage account"
  default     = {}
  type        = object({})
}

variable "customer_managed_key" {
  description = "customer supplied managed key for encryption"
  default     = {}
  type        = map(any)
}

variable "default_to_oauth_authentication" {
  description = "Use AAD for storage account access within the portal"
  default     = false
  type        = bool
}

variable "edge_zone" {
  description = "The edge zone within the Azure region where this storage account should reside"
  default     = null
  type        = string
}

variable "enable_https_traffic_only" {
  description = "Force HTTPS?"
  default     = true
  type        = bool
}

variable "enable_private_endpoint" {
  description = "Should private endpoints be used?"
  type        = bool
}

variable "file_share" {
  description = "Should a file share be created?"
  default     = false
  type        = bool
}

variable "iam" {
  description = "Account level RBAC assignments"
  type = map(object({
    principal_id         = string
    role_definition_name = string
  }))
}

variable "identity" {
  description = "Managed Identities to create - by default System Managed Identity"
  type = object({
    identity_ids = list(string)
    type         = string
  })
}

variable "immutability_policy" {
  description = "The default account-level immutability policy"
  default     = {}
  type        = map(any)
}

variable "infrastructure_encryption_enabled" {
  description = "Enable infrastructure encryption?"
  default     = false
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
  type        = string
}

variable "network_rules" {
  description = "Network rules to assign to the storage account"
  type = object({
    bypass                     = list(string)
    default_action             = string
    ip_rules                   = list(string)
    private_link_access        = object({})
    virtual_network_subnet_ids = list(string)
  })
}

variable "nfsv3_enabled" {
  description = "Enable NFS protcol?"
  default     = false
  type        = bool
}

variable "private_dns_zone_ids" {
  description = "A list of Private DNS zone to integrate with Private Endpoint"
  default     = []
  type        = list(string)
}

variable "file_private_dns_zone_ids" {
  description = "A list of Private DNS zone to integrate with Private Endpoint"
  default     = []
  type        = list(string)
}

variable "table_private_dns_zone_ids" {
  description = "A list of Private DNS zone to integrate with Private Endpoint"
  default     = []
  type        = list(string)
}

variable "queue_private_dns_zone_ids" {
  description = "A list of Private DNS zone to integrate with Private Endpoint"
  default     = []
  type        = list(string)
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
  type        = map(any)
}

variable "routing" {
  description = "Storage network routing"
  default     = {}
  type        = map(any)
}

variable "sas_policy" {
  description = ""
  default     = {}
  type        = map(any)
}

variable "sftp_enabled" {
  description = "Should SFTP be enabled? - HNS must be enabled too"
  default     = false
  type        = bool
}

variable "share_properies" {
  description = "Queue properties"
  default     = {}
  type        = map(any)
}

variable "shared_access_key_enabled" {
  description = "Can the storage acount be accessed using the shared key?"
  default     = true
  type        = bool
}

variable "static_website" {
  description = ""
  default     = {}
  type        = map(any)
}

variable "table_encryption_key_type" {
  description = "Service or Account encryption?"
  default     = "Service"
  type        = string
}

variable "tags" {
  description = "A map of tags"
  type        = map(any)
}

variable "virtual_network_subnet_private_endpoint_id" {
  description = "The subnet associated with the Private Endpoint"
  default     = ""
  type        = string
}