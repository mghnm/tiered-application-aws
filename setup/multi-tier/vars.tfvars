################ Project Configs ################

# Ending the resource prefix with a hyphen '-' allows it to be separated from the name
resource_prefix = "multi-tier-"

# Region to deploy the resources
region = "eu-north-1"

# Availability zones on which to deploy the subnets
# This list also functions as a count of how many private and public subnets to make
# For each availability zone specified a public subnet and private subnet will be made
availability_zones = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]

################ VPC Vars ################

# The VPC cider size
vpc_cider_block = "10.0.0.0/16"

# The /x size of the subnets when using cidrsubnet() in terraform
# Is calculated as following /x = vpc_cider_block_size + newbits
# In this example to /x = 16 + 8 = /24
vpc_subnet_newbits = 8

################ EC2 Vars ################

# Instance type to use for the compute instances
# Notice: t3-micro is available in free tier for a year
instance_type = "t3.micro"
key_pair_name = "wsl-key"
ami           = "ami-0f0b4cb72cf3eadf3"

################ DB Vars ################
db_user = "mydbuser"
db_pass = "mydbpass2"