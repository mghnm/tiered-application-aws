# # We need our auto scaling group to be defined and that requires a launch template and possibly other things

# ################### FE ###################
# resource "aws_launch_template" "fe-template" {
#   name          = "fe-template"
#   image_id      = var.ami
#   instance_type = "t3.micro"
#   key_name      = "wsl-key"

#   tags = {
#     Name = "${var.resource_prefix}fe-launch-template"
#   }
# }

# resource "aws_autoscaling_group" "autoscaling-fe" {
#   max_size           = 3
#   min_size           = 3
#   launch_template {
#     id      = aws_launch_template.fe-template.id
#     version = "$Latest"
#   }
#   health_check_grace_period = 60
#   health_check_type         = "ELB"
#   vpc_zone_identifier = var.private_subnets
#   target_group_arns = [aws_lb_target_group.alb.arn]

# }


# ################### BE ###################
# resource "aws_launch_template" "be-template" {
#   name          = "fe-template"
#   image_id      = var.ami
#   instance_type = "t3.micro"
#   key_name      = "wsl-key"

#   tags = {
#     Name = "${var.resource_prefix}be-launch-template"
#   }
# }

# resource "aws_autoscaling_group" "autoscaling-be" {
#   max_size           = 3
#   min_size           = 3
#   launch_template {
#     id      = aws_launch_template.be-template.id
#     version = "$Latest"
#   }
#   health_check_grace_period = 60
#   health_check_type         = "ELB"
#   vpc_zone_identifier = var.private_subnets
#   #target_group_arns = 

# }

