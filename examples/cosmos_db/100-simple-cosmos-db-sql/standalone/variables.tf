
variable "global_settings" {
  default = {}
}

variable "tags" {
  default = null
  type    = map(any)
}

variable "resource_groups" {
  default = null
}

variable "cosmos_dbs" {
  default = {}
}

variable "var_folder_path" {
  default = {}
}