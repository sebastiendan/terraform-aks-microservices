variable "resource_group" {
  description = "Resource group name"
}

variable "location" {
  description = "Location where the resource exists"
}

variable "storage_account_name" {
  description = "Blob storage account name"
}

variable "account_tier" {
  default = "Standard"
  description = "Blob storage account tier"
}

variable "account_replication_type" {
  default = "LRS"
  description = "Blob storage account replication type"
}