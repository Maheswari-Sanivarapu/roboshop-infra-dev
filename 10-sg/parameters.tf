resource "aws_ssm_parameter" "sg_id" {
  name  = "/${var.project}/${var.environment}/frontend_sg_id" # creating the name
  type  = "String"
  value = module.frontend.sg_id # getting the .sg_id from output exposed from terraform-aws-security-group-module
}