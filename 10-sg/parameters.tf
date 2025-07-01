resource "aws_ssm_parameter" "frontend_sg_id" {
  name  = "/${var.project}/${var.environment}/frontend_sg_id" # # creating the name for frontend sg-id to store it in ssm parameter store
  type  = "String"
  value = module.frontend.sg_id # getting the .sg_id from output exposed from terraform-aws-security-group-module and calling the frontend module
}

resource "aws_ssm_parameter" "bastion_sg_id" {
  name  = "/${var.project}/${var.environment}/bastion_sg_id" # creating the name for bastion sg-id to store it in ssm parameter store
  type  = "String"
  value = module.bastion.sg_id # getting the .sg_id from output exposed from terraform-aws-security-group-module and calling the bastion module
}

resource "aws_ssm_parameter" "backend_alb_sg_id" {
  name = "/${var.project}/${var.environment}/backend_alb_sg_id" # creating the name for backend-alb sg-id to store it in ssm parameter store
  type  = "String"
  value = module.backend_alb.sg_id  # getting the .sg_id from output exposed from terraform-aws-security-group-module and calling the backend-alb module
}

resource "aws_ssm_parameter" "openvpn_sg_id" {
  name = "/${var.project}/${var.environment}/openvpn_sg_id"
  type  = "String"
  value = module.openvpn.sg_id
}

resource "aws_ssm_parameter" "mongodb_sg_id" {
  name = "/${var.project}/${var.environment}/mongodb_sg_id"
  type  = "String"
  value = module.mongodb.sg_id
}

resource "aws_ssm_parameter" "redis_sg_id" {
  name = "/${var.project}/${var.environment}/redis_sg_id"
  type  = "String"
  value = module.redis.sg_id
}

resource "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${var.project}/${var.environment}/mysql_sg_id"
  type  = "String"
  value = module.mysql.sg_id
}

resource "aws_ssm_parameter" "rabbitmq_sg_id" {
  name = "/${var.project}/${var.environment}/rabbitmq_sg_id"
  type  = "String"
  value = module.rabbitmq.sg_id
}

resource "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/${var.project}/${var.environment}/catalogue_sg_id"
  type  = "String"
  value = module.catalogue.sg_id
}