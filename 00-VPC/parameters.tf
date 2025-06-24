resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project}/${var.environment}/vpc_id" # creating the name
  type  = "String"
  value = module.vpc.vpc_id # getting the .vpc_id from output exposed from terraform-aws-vpc-module
}