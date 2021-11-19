module "vpc" {
  source             = "../../modules/vpc/"
  resource_prefix    = var.resource_prefix
  availability_zones = var.availability_zones
  vpc_cider_block    = var.vpc_cider_block
  vpc_subnet_newbits = var.vpc_subnet_newbits
}

module "ec2" {
  source          = "../../modules/ec2/"
  resource_prefix = var.resource_prefix
  instance_type   = var.instance_type
  key_pair_name   = var.key_pair_name
  ami             = var.ami
  vpc             = module.vpc.vpc_id
  vpc_cider_block = module.vpc.vpc_cider_block
  private_subnets = module.vpc.vpc_private_subnet_ids
  public_subnets  = module.vpc.vpc_public_subnet_ids
  db_user         = var.db_user
  db_pass         = var.db_pass
}

module "db" {
  source          = "../../modules/db/"
  resource_prefix = var.resource_prefix
  private_subnets = module.vpc.vpc_private_subnet_ids
  db_user         = var.db_user
  db_pass         = var.db_pass
}