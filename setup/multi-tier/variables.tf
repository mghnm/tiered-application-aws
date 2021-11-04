################ Project Configs ################

variable "resource_prefix" {
  type        = string
  description = "Optional prefix, that can be appended to all resource names for easy identification."
  default     = ""
}

variable "region" {
  type        = string
  description = "Default region to use for the resources."
  default     = "eu-north-1"
}

# Check to make sure the region set matches the availability zones
# $ aws ec2 describe-availability-zones --region eu-north-1
variable "availability_zones" {
  type        = list(string)
  description = "A list of availability zones in which the subnets exist."
  default     = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
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


################ DB Vars ################
variable "db_user" {
  type        = string
  description = "The username for the database user."
}

variable "db_pass" {
  type        = string
  description = "The password for the database user."
}
