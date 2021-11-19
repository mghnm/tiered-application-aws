# Allow only ssh from external to vpc on my IP
resource "aws_security_group" "bastions" {

  name        = "Security Group Bastions"
  description = "Allow only ssh to the bastions"
  vpc_id      = var.vpc

  # CIDR BLOCK FOR MY ISP 213.89.4.0/22 but I can also limit to my own ip 213.89.6.192/32
  ingress {
    description = "allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["213.89.6.192/32"]
  }
  # Allow outbound traffic to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Allow SSH and HTTP from within VPC
resource "aws_security_group" "private_instances" {

  name        = "Security Group Private Instances"
  description = "Allow only VPC ssh"
  vpc_id      = var.vpc

  # CIDR BLOCK FOR MY VPC
  ingress {
    description = "allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cider_block]
  }

  ingress {
    description = "allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cider_block]
  }

  ingress {
    description = "allow db"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cider_block]
  }

  # Allow outbound traffic to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}