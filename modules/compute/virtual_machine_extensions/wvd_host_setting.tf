resource "azurerm_virtual_machine_extension" "domainJoin" {
  for_each = var.extension_name == "microsoft_azure_domainJoin" ? toset(["enabled"]) : toset([])
  name                       = "microsoft_azure_domainJoin"
  # location                   = "${var.region}"
  # resource_group_name        = var.resource_group_name
  virtual_machine_id         = var.virtual_machine_id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = try(var.extension.type_handler_version, "1.3")
  auto_upgrade_minor_version = try(var.extension.auto_upgrade_minor_version, true)
  # depends_on                 = ["azurerm_virtual_machine_extension.LogAnalytics"]

  lifecycle {
    ignore_changes = [
      "settings",
      "protected_settings",
    ]
  }

  settings = <<SETTINGS
    {
        "Name": "${var.domain_name}",
        "OUPath": "${var.ou_path}",
        "User": "adminaad@demos.llc",
        "Restart": "true",
        "Options": "3"
    }
    
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
         "Password": "${var.domain_password}"
  }
PROTECTED_SETTINGS

  # tags {
  #   BUC             = "${var.tagBUC}"
  #   SupportGroup    = "${var.tagSupportGroup}"
  #   AppGroupEmail   = "${var.tagAppGroupEmail}"
  #   EnvironmentType = "${var.tagEnvironmentType}"
  #   CustomerCRMID   = "${var.tagCustomerCRMID}"
  # }
}

# locals {
#   microsoft_azure_domainJoin = {
#     template_path = var.extension_name == "microsoft_azure_domainJoin" ? fileexists(var.settings.xml_diagnostics_file) ? var.settings.xml_diagnostics_file : format("%s/%s", var.settings.var_folder_path, var.settings.xml_diagnostics_file) : null
#   }
# }

resource "azurerm_virtual_machine_extension" "custom_script_extensions" {
  for_each = var.extension_name == "extension_custom_script" ? toset(["enabled"]) : toset([])
  name                 = "custom_script_extensions"
  # location             = "${var.region}"
  # resource_group_name  = "${var.resource_group_name}"
  virtual_machine_id   = var.virtual_machine_id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  depends_on           = ["azurerm_virtual_machine_extension.domainJoin"]
  type_handler_version = "1.9"

  lifecycle {
    ignore_changes = [
      "settings",
    ]
  }

  settings = <<SETTINGS
    {
      "fileUris": ["${join("\",\"", var.extensions_custom_script_fileuris)}"],
      "commandToExecute": "${var.extensions_custom_command}"
    }
SETTINGS

  # tags {
  #   BUC             = "${var.tagBUC}"
  #   SupportGroup    = "${var.tagSupportGroup}"
  #   AppGroupEmail   = "${var.tagAppGroupEmail}"
  #   EnvironmentType = "${var.tagEnvironmentType}"
  #   CustomerCRMID   = "${var.tagCustomerCRMID}"
  # }
}

resource "azurerm_virtual_machine_extension" "additional_session_host_dscextension" {
  for_each = var.extension_name == "additional_session_host_dscextension" ? toset(["enabled"]) : toset([])
  name                       = "additional_session_host_dscextension"
  # location                   = "${var.region}"
  # resource_group_name        = "${var.resource_group_name}"
  virtual_machine_id         = var.virtual_machine_id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true
  depends_on                 = ["azurerm_virtual_machine_extension.domainJoin", "azurerm_virtual_machine_extension.custom_script_extensions"]

  settings = <<SETTINGS
{
    "modulesURL": "${var.base_url}/DSC/Configuration.zip",
    "configurationFunction": "Configuration.ps1\\RegisterSessionHost",
     "properties": {
        "TenantAdminCredentials":{
          "userName":"${var.svcprincipal_app_id}",
          "password":"PrivateSettingsRef:tenantAdminPassword"
        },
        "RDBrokerURL":"${var.RDBrokerURL}",
        "DefinedTenantGroupName":"${var.existing_tenant_group_name}",
        "TenantName":"${var.wvd_tenant_name}",
        "HostPoolName":"${var.host_pool_name}",
        "Hours":"${var.registration_expiration_hours}",
        "isServicePrincipal":"${var.is_service_principal}",
        "AadTenantId":"${var.aad_tenant_id}"        
  }
}
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
{
  "items":{
    "tenantAdminPassword":"${var.svcprincipal_creds_value}"
  }
}
PROTECTED_SETTINGS

  # tags {
  #   BUC             = "${var.tagBUC}"
  #   SupportGroup    = "${var.tagSupportGroup}"
  #   AppGroupEmail   = "${var.tagAppGroupEmail}"
  #   EnvironmentType = "${var.tagEnvironmentType}"
  #   CustomerCRMID   = "${var.tagCustomerCRMID}"
  # }
}