# # Load balancers are needed with the auto scaling groups so that we can ensure content is served up properly

# ###################### ALB ######################

# # External facing application load balancer
# resource "aws_lb" "alb" {
#   name               = "alb"
#   internal           = false
#   load_balancer_type = "application"
#   # security_groups    = [aws_security_group.lb_sg.id]
#   subnets            = var.public_subnets
#   enable_deletion_protection = false

#   tags = {
#     Name = "${var.resource_prefix}alb"
#   }
# }

# # The load balancer target group (Our auto-scaling group needs to belong to this group)
# resource "aws_lb_target_group" "alb" {
#   name     = "alb-target-group"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = var.vpc

#   tags = {
#     Name = "${var.resource_prefix}alb-target-group"
#   }
# }

# # The listening rule (what to do when traffic comes)
# resource "aws_lb_listener" "front_end" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb.arn
#   }
# }

# ###################### Internal Load Balancer ######################

# # Use TCP load-balancer or applicaion load-balancer for internal load balancing
# resource "aws_elb" "bar" {
#    name               = "foobar-terraform-elb"
#    subnets = var.private_subnets

#    # If you need multiple subnets then provide value as follow
#    # subnets = ["subnet-1-id", "subnet-2-id"]

#    internal = true

#    listener {
#      instance_port     = 8000
#      instance_protocol = "http"
#      lb_port           = 80
#      lb_protocol       = "http"
#    }

#    health_check {
#      healthy_threshold   = 2
#      unhealthy_threshold = 2
#      timeout             = 3
#      target              = "HTTP:8000/"
#      interval            = 30
#    }

#    instances                   = ["i-xxxxxxxxxxxxxxx"]
#    idle_timeout                = 400
#    connection_draining         = true
#    connection_draining_timeout = 400

#    tags = {
#      Name = "${var.resource_prefix}elb"
#    }
#   }