variable "services" {
  type = "list"
  default = [
    {
      name = "redis",
      image = "redis",
      version = "5.0.2",
      replicas = 1
      port = 80,
      target_port = 6379,
    },
    {
      name = "api_gateway",
      image = "",
      version = "master",
      replicas = 2
      port = 80,
      target_port = 3000,
    },
    {
      name = "microservice1",
      image = "",
      version = "master",
      replicas = 2
      port = 3000,
      target_port = 3000,
    },
    {
      name = "microservice2",
      image = "",
      version = "master",
      replicas = 2
      port = 3000,
      target_port = 3000,
      db = "mysql",
    },
  ]
}

variable "resource_group" {
  description = "Resource group name"
}

variable "location" {
  description = "Location where the resource exists"
}

variable "namespace" {
  description = "K8S namespace name"
}

variable "db_host" {
  description = "DB host"
}

variable "db_admin_username" {
  description = "DB admin username"
}

variable "db_admin_password" {
  description = "DB admin user password"
}

variable "blob_storage_account_name" {
  description = "Blob storage account name"
}

variable "blob_storage_account_access_key" {
  description = "Blob storage account key"
}