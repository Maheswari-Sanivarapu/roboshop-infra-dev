resource "aws_instance" "bastion" {
    ami = local.ami_id
    instance_type = "t2.micro"
    vpc_security_group_ids = [local.bastion_sg_id]
    subnet_id = local.public_subnet_id # creating the bastion in public subnet
    user_data = file("bastion.sh")
    tags = merge (
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-basiton"
        }
    )
}