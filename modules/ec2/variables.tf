################ Project Configs ################

variable "resource_prefix" {
  type        = string
  description = "Optional prefix, that can be appended to all resource names for easy identification."
  default     = ""
}


################ EC2 Vars ################

variable "instance_type" {
  type        = string
  description = "The EC2 instance type to be used for EC2 instances."
}

variable "key_pair_name" {
  type        = string
  description = "The name of the key_pair that will be allowed to ssh into the bastion machines."
}

variable "ami" {
  type        = string
  description = "The ami for the instaces that will be deployed."
}


################ Imported Variables from vpc module ################

variable "private_subnets" {
  type        = list(string)
  description = "The ids of the private_subnets to deploy private instances on."
}

variable "public_subnets" {
  type        = list(string)
  description = "The ids of the public_subnets to deploy the bastion instances on."
}

variable "vpc" {
  type        = string
  description = "The id of the vpc that the security groups will be deployed on."
}

variable "vpc_cider_block" {
  type        = string
  description = "The cidr block for the vpc to limit access to instances."

}

