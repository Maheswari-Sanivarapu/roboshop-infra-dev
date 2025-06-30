locals {
    openvpn_ami_id = data.aws_ami.openvpn_ami.id
    openvpn_sg_id = data.aws_ssm_parameter.openvpn_sg_id.value
    public_subnet_id = split(",",data.aws_ssm_parameter.public_subnet_id.value)[0]
    common_tags = {
        project = var.project
        environment = var.environment
    }
}