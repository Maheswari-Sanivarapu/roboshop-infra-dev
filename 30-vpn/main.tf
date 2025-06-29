resource "aws_key_pair" "openvpn"{
    key_name = "pavikey"
    public_key = file("C:\\Users\\saniv\\pavikey")
}
resource "aws_instance" "vpn" {
    ami = local.openvpn_ami_id
    instance_type = "t2.micro"
    vpc_security_group_ids = [local.openvpn_sg_id]
    subnet_id = local.subnet_id
    user_data = file("openvpn.sh")
    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-openvpn"
        }
    )
}