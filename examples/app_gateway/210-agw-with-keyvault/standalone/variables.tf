
variable "global_settings" {
  default = {}
}

variable "tags" {
  default = null
  type    = map(any)
}
variable "app_service_environments" {
  default = {}
}
variable "app_service_plans" {
  default = {}
}
variable "app_services" {
  default = {}
}
variable "diagnostics_definition" {
  default = null
}
variable "resource_groups" {
  default = null
}
variable "network_security_group_definition" {
  default = {}
}
variable "vnets" {
  default = {}
}
variable "storage_accounts" {
  default = {}
}
variable "azuread_groups" {
  default = {}
}
variable "keyvaults" {
  default = {}
}
variable "keyvault_access_policies" {
  default = {}
}
variable "keyvault_certificates" {
  default = {}
}
variable "public_ip_addresses" {
  default = {}
}
variable "diagnostic_storage_accounts" {
  default = {}
}
variable "managed_identities" {
  default = {}
}
variable "private_dns" {
  default = {}
}
variable "synapse_workspaces" {
  default = {}
}
variable "azurerm_application_insights" {
  default = {}
}
variable "role_mapping" {
  default = {}
}
variable "monitoring" {
  default = {}
}
variable "event_hub_namespaces" {
  default = {}
}
variable "application_gateways" {
  default = {}
}
variable "application_gateway_applications" {
  default = {}
}