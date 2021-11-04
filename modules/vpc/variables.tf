################ Project Configs ################

variable "resource_prefix" {
  type        = string
  description = "Optional prefix, that can be appended to all resource names for easy identification."
  default     = ""
}

variable "availability_zones" {
  type        = list(string)
  description = "A list of availability zones in which the subnets exist."
}

################ VPC Vars ################

variable "vpc_cider_block" {
  type        = string
  description = "The cider block which will be used for the VPC."
}

variable "vpc_subnet_newbits" {
  type        = number
  description = "The newbits to add on top of the vpc cider block size. Determines the subnet size"
}