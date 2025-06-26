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

# creating the security group for bastion server
module "bastion" {
    source = "git::https://github.com/mahi2298/terraform-aws-security-group-module.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.bastion_sg_name
    sg_description = var.bastion_sg_description
    vpc_id = local.vpc_id
}

# creating security group for application load balancer
module "backend_alb" {
    source = "git::https://github.com/mahi2298/terraform-aws-security-group-module.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "backend-alb"
    sg_description = "backend-application-load-balancer"
    vpc_id = local.vpc_id
}

# giving connection from laptop to bastion by creating the security group for basiton and allowing only incoming traffic on port 22 for bastion
resource "aws_security_group_rule" "bastion_laptop" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.bastion.sg_id
}

# giving connection from bastion to alb by creating the security group for backend-alb and allowing only port 80 and also sg-id of bastion to alb as the incoming traffic
# bcoz for load balancer incoming traffic of port 80 only will be allowed in order to get trrafic from outside we are using the sg-id of bastion bcoz this bastion will be in public subnet 
# from laptop --> bastion server (created in public subnet) --> load balancer (created in private subnet)
resource "aws_security_group_rule" "backend_alb_bastion" {
    type = "ingress" 
    from_port = 80 # allowing port 80 as incoming traffic
    to_port = 80 # allowing port 80 as incoming traffic
    protocol = "tcp"
    source_security_group_id = module.bastion.sg_id # taking the sg id of bastion and attaching it to to backend-alb as incoming traffic
    security_group_id = module.backend_alb.sg_id # backend-alb security id
}