# Since we are creating several subnets we can use
# 1. Terrafrom count for cloning with length()
# 2. Terraform cidrsubnet with offsets for the cidr_blocks
# 3. Terraform element for getting one item from the list
resource "aws_subnet" "private-subnets" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cider_block, var.vpc_subnet_newbits, count.index)
  availability_zone = element(var.availability_zones, count.index)


  tags = {
    Name = "${var.resource_prefix}private-subnet-${count.index}"
  }
}

# Notice: In cidrsubnet we add the length of the list as an offset
# so that we don't overlap with the public subnets
resource "aws_subnet" "public-subnets" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cider_block, var.vpc_subnet_newbits, count.index + length(var.availability_zones))
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.resource_prefix}public-subnet-${count.index}"
  }
}