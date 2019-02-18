output "account_name" {
  description   = "Storage account name"
  value         = "${azurerm_storage_account.account.name}"
}

output "account_access_key" {
  description   = "Storage account access key"
  value         = "${azurerm_storage_account.account.primary_access_key}"
}