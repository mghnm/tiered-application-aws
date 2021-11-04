# Create a bastion on each public subnet
resource "aws_instance" "bastions" {
  count                       = length(var.public_subnets)
  ami                         = var.ami
  key_name                    = var.key_pair_name
  instance_type               = var.instance_type
  vpc_security_group_ids      = ["${aws_security_group.bastions.id}"]
  subnet_id                   = element(var.public_subnets, count.index)
  associate_public_ip_address = true

  tags = {
    Name = "${var.resource_prefix}bastion-public-subnet-${count.index}"
  }
}