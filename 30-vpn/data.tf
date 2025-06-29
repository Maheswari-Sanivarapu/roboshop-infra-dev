data "ami_id" "vpn_ami" {
    owners      = ["679593333241"]
    most_recent = true # latest version lo crate chestudi ee command
    filter {
        name   = "name"
        values = ["OpenVPN Access Server Community Image-8fbe3379-*"]
    }
}

data "aws_ssm_parameter" "openvpn_sg_id" {
  name = "/${var.project}/${var.environment}/openvpn_sg_id"
}

data "aws_ssm_parameter" "public_subnet_id" {
  name  = "/${var.project}/${var.environment}/public_subnet_id"
}
