################ Imported Variables from vpc module ################

variable "private_subnets" {
  type        = list(string)
  description = "The ids of the private_subnets to deploy private instances on."
}

################ Variables from tfvars ################
variable "db_user" {
  type        = string
  description = "The username for the database user."
}

variable "db_pass" {
  type        = string
  description = "The password for the database user."
}

################ Project Configs ################

variable "resource_prefix" {
  type        = string
  description = "Optional prefix, that can be appended to all resource names for easy identification."
  default     = ""
}
