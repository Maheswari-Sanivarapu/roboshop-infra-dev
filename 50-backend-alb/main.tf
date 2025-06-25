#roboshop-dev-backend-alb
module "alb" {
    source = "terraform-aws-modules/alb/aws"
    version = "9.17.0"
    internal = true # means this load balancer will be create in private subnet only. internal = false means it will create in public subnet
    name = "${var.project}-${var.environment}-backend-alb"
    vpc_id = local.vpc_id
    subnets = local.private_subnet_ids # creating the alb in private subnet
    security_groups = local.backend_alb_sg_id  # getting the backend sg id from 10-sg bcoz in 10-sg it is created
    tags = merge (
        var.common_tags,
        {
            Name = "${var.project}-${var.environment}-backend-alb"
        }
    )
}