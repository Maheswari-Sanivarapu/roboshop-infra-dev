resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project}/${var.environment}/vpc_id" # creating the name for vpc-id
  type  = "String"
  value = module.vpc.vpc_id # getting the .vpc_id from output exposed from terraform-aws-vpc-module and calling the module
}

resource "aws_ssm_parameter" "public_subnet_id" {
  name  = "/${var.project}/${var.environment}/public_subnet_id" # creating the name for public-subnet-id
  type  = "StringList" # here the subnet is list
  value = join(",",module.vpc.public_subnet_id) # getting the .public_subnet_id from output exposed from terraform-aws-vpc-module and calling the module and converting the list to string using join function
}

resource "aws_ssm_parameter" "private_subnet_id" {
  name  = "/${var.project}/${var.environment}/private_subnet_id" # creating the name for private-subnet-id
  type  = "StringList" # here the subnet is list
  value = join(",",module.vpc.private_subnet_id) # getting the .private_subnet_id from output exposed from terraform-aws-vpc-module and calling the module and converting the list to string using join function
}
# performs the opposite operation: producing a string joining together a list of strings with a given separator.
# so here join function will convert list to string and append with , here