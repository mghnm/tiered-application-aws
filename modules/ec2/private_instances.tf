# # Create an instance on each private subnet
# resource "aws_instance" "private_instances" {
#   count                  = length(var.private_subnets)
#   ami                    = var.ami
#   key_name               = var.key_pair_name
#   instance_type          = var.instance_type
#   vpc_security_group_ids = ["${aws_security_group.private_instances.id}"]
#   subnet_id              = element(var.private_subnets, count.index)

#   tags = {
#     Name = "${var.resource_prefix}private-instance-private-subnet-${count.index}"
#   }
# }