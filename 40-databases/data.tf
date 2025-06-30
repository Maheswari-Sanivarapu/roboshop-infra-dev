data "aws_ami" "databases_ami" {
    owners      = ["973714476881"]
    most_recent = true # latest version lo crate chestudi ee command
    filter {
        name   = "name"
        values = ["RHEL-9-DevOps-Practice"]
    }
    filter {
        name   = "root-device-type"
        values = ["ebs"]
  }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

data "aws_ssm_parameter" "database_subnet_id" {
  name  = "/${var.project}/${var.environment}/database_subnet_id"
}


data "aws_ssm_parameter" "mongodb_sg_id" {
  name = "/${var.project}/${var.environment}/mongodb_sg_id"
}


data "aws_ssm_parameter" "redis_sg_id" {
  name = "/${var.project}/${var.environment}/redis_sg_id"
}


data "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${var.project}/${var.environment}/mysql_sg_id"
}

data "aws_ssm_parameter" "rabbitmq_sg_id" {
  name = "/${var.project}/${var.environment}/rabbitmq_sg_id"
}