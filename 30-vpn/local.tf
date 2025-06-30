locals {
    openvpn_ami_id = data.ami_id.vpn_ami
    openvpn_sg_id = data.aws_ssm_parameter.openvpn_sg_id
    public_subnet_id = data.aws_ssm_parameter.public_subnet_id
    common_tags = {
        project = var.project
        environment = var.environment
    }
}