################ Nat Routing ################

# Create the tables
resource "aws_route_table" "private-subnets" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.resource_prefix}private-route-table-${element(var.availability_zones, count.index)}"
  }
}

# Create the nat route
resource "aws_route" "all-through-nat" {
  count                  = length(var.availability_zones)
  route_table_id         = element(aws_route_table.private-subnets.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nats.*.id, count.index)
}


# Create the private subnet to route table association
resource "aws_route_table_association" "private-subnets-to-private-route-tables" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.private-subnets.*.id, count.index)
  route_table_id = element(aws_route_table.private-subnets.*.id, count.index)
}

################ IGW Routing ################

# We are going to expose our public subnets to the internet
# The way this is done is through routing the traffic through
# An internet gateway

# Create the table
resource "aws_route_table" "public-subnets" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.resource_prefix}public-route-table"
  }
}

# Create the route
resource "aws_route" "all-through-igw" {
  count                  = length(var.availability_zones)
  route_table_id         = aws_route_table.public-subnets.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Create the public subnet to route table association
resource "aws_route_table_association" "public-subnets-to-public-route-table" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.public-subnets.*.id, count.index)
  route_table_id = aws_route_table.public-subnets.id
}
