# We want to expose every subnet through a nat for security reasons
resource "aws_nat_gateway" "nats" {
  count             = length(var.availability_zones)
  connectivity_type = "public"
  allocation_id     = element(aws_eip.public-nat-ips.*.id, count.index)
  subnet_id         = element(aws_subnet.public-subnets.*.id, count.index)

  tags = {
    Name = "${var.resource_prefix}nat-${element(var.availability_zones, count.index)}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the eips
  depends_on = [aws_eip.public-nat-ips]

}


# Every nat will need a public ip so it can be reachable
resource "aws_eip" "public-nat-ips" {
  count = length(var.availability_zones)
  vpc   = true
}
