resource "aws_key_pair" "openvpn"{
    key_name = "openvpn" # name should be openvpn
    public_key = file("C:\\Users\\saniv\\openvpn.pub") # loading the openvpn.pub file from local i.e. from laptop
}
resource "aws_instance" "vpn" {
    ami = local.openvpn_ami_id 
    instance_type = "t2.micro"
    vpc_security_group_ids = [local.openvpn_sg_id]
    subnet_id = local.public_subnet_id  # public_subnet_id taking from 00-VPC
    #key_name = "daws-84s" # make sure this key exist in AWS
    key_name = aws_key_pair.openvpn.key_name
    user_data = file("openvpn.sh") # creating the openvpn.sh and adding the required files to run openvpn and here user_data will run while creating the instance
    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-openvpn"
        }
    )
}

resource "aws_route53_record" "openvpn" {
    zone_id = var.route53_zone_id
    name = "vpn-${var.environment}.${var.route53_domain_name}"
    type = "A"
    ttl = 1
    records = [aws_instance.vpn.public_ip]
    allow_overwrite = true
}