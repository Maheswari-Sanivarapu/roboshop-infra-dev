#roboshop-dev-backend-alb
module "alb" {
    source = "terraform-aws-modules/alb/aws"
    name = "${var.project}-${var.environment}-backend-alb"
    vpc_id = local.vpc_id
    #subnets = 
}