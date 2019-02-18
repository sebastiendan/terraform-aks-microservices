variable "resource_group" {
  description = "Resource group name"
}

variable "location" {
  description = "Location where the resource exists"
}

variable "server_name" {
  description = "MySQL Server name"
}

variable "admin_username" {
  description   = "The administrator username of the MySQL server"
}

variable "admin_password" {
  description   = "The administrator password of the MySQL server"
}

variable "start_ip_address" {
  description   = "The start IP address used in your database firewall rule"
  default       = "0.0.0.0"
}

variable "end_ip_address" {
  description   = "The end IP address used in your database firewall rule"
  default       = "255.255.255.255"
}

variable "db_version" {
  description   = "The version of MySQL to use"
  default       = "5.7"
}

variable "ssl_enforcement" {
  description   = "Specifies if SSL should be enforced on connections. Possible values are Enabled or Disabled."
  default       = "Enabled"
}

variable "sku_name" {
  description   = "Specifies the SKU Name for this MySQL Server. The name of the SKU, follows the tier + family + cores pattern (e.g. B_Gen4_1, GP_Gen5_8)."
  default       = "GP_Gen4_2"
}

variable "sku_capacity" {
  description   = "The scale up/out capacity, representing server's compute units"
  default       = 2
}

variable "sku_tier" {
  description   = "The tier of the particular SKU. Possible values are Basic, General Purpose."
  default       = "GeneralPurpose"
}

variable "sku_family" {
  description   = "The family of hardware Gen4 or Gen5, before selecting your family check the product documentation for availability in your region."
  default       = "Gen4"
}

variable "storage_mb" {
  description   = "Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 4194304 MB(4TB) for General Purpose/Memory Optimized SKUs."
  default       = 51200
}

variable "geo_redundant_backup" {
  description   = "Enable Geo-redundant or not for server backup. Valid values for this property are Enabled or Disabled, not supported for the basic tier."
  default       = "Enabled"
}

variable "backup_retention_days" {
  description   = "Backup retention days for the server, supported values are between 7 and 35 days"
  default       = 7
}

variable "charset" {
  description   = "Specifies the Charset for the MySQL Database, which needs to be a valid MySQL Charset"
  default       = "utf8"
}