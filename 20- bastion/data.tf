data "aws_ami" "ami_id" {
    Owners = ["973714476881"]
    most_recent = true
    filter = {
        name = "name"
        value = ["RHEL-9-DevOps-Practice"]
    }
}

resource "aws_ssm_parameter" "bastion_sg_id" {
  name  = "/${var.project}/${var.environment}/bastion_sg_id"
}

resource "aws_ssm_parameter" "public_subnet_id" {
  name  = "/${var.project}/${var.environment}/public_subnet_id"
}