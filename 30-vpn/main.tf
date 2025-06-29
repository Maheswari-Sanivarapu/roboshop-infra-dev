resource "aws_instance" "openvpn" {
    ami = local.openvpn_ami_id
    instance_type = "t2.micro"
    vpc_security_group_ids = [local.openvpn_sg_id]
    subnet_id = local.subnet_id
    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-openvpn"
        }
    )
}