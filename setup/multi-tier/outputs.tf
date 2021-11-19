output "vpc_id" {
  value = module.vpc.vpc_id
  description = "The VPC self-link used to identify the VPC."
}

output "vpc_cider_block" {
  value = module.vpc.vpc_cider_block
  description = "The VPC CIDR block representing the allocatable ids."
}

output "vpc_public_subnet_ids" {
  value = module.vpc.vpc_public_subnet_ids
  description = "The subnet self-links used to identify the created public subnets."
}

output "vpc_private_subnet_ids" {
  value = module.vpc.vpc_private_subnet_ids
  description = "The subnet self-links used to identify the created privte subnets."
}

output "bastion_ips" {
  value = module.ec2.bastion_ips
  description = "Bastion public ip addresses."
}

# output "db-info" {
#     value = module.db.db-info
#     description = "Database key information."
# }