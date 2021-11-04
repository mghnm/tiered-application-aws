resource "aws_vpc" "main" {
  cidr_block = var.vpc_cider_block

  tags = {
    Name = "${var.resource_prefix}vpc"
    role = "peering"
  }
}