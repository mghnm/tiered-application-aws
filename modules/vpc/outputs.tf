output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cider_block" {
  value = aws_vpc.main.cidr_block
}

output "vpc_public_subnet_ids" {
  value = aws_subnet.public-subnets.*.id
}

output "vpc_private_subnet_ids" {
  value = aws_subnet.private-subnets.*.id
}
