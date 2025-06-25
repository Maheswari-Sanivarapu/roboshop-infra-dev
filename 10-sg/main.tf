module "frontend" {
    #source = "../../terraform-aws-security-group-module"
    source = "git::https://github.com/mahi2298/terraform-aws-security-group-module.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.frontend_sg_name
    sg_description = var.frontend_sg_description
    vpc_id = local.vpc_id # retrieving the vpc id using data source and calling that value here
}

# here we are storing this value in ssm parameter store i.e. in parameters.tf
output "sg_id" {
    value = module.frontend.sg_id # here .sg_id is exposed from output of terraform-aws-security-group-module
}

module "bastion" {
    source = "git::https://github.com/mahi2298/terraform-aws-security-group-module.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.bastion_sg_name
    sg_description = var.bastion_sg_description
    vpc_id = local.vpc_id
}

resource "aws_security_group_rule" "bastion_laptop" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.bastion.sg_id
}