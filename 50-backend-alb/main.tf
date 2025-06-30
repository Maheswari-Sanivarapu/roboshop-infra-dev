#roboshop-dev-backend-alb
module "alb" {
    source = "terraform-aws-modules/alb/aws" # teking the module from terraform_aws_alb documentation
    version = "9.16.0" # giving the version from terraform_aws_alb bcoz in provider version is diff and here it is diff to make compatible adding that module specific version here so either change version in provider or specify version here
    internal = true # means this load balancer will be create in private subnet only. internal = false means it will create in public subnet
    #enable_deletion_protection = true
    name = "${var.project}-${var.environment}-backend-alb"
    vpc_id = local.vpc_id
    subnets = local.private_subnet_ids # creating the alb in private subnet bcoz this is for backend and backend should be in private subnet
    security_groups = [local.backend_alb_sg_id]  # getting the backend sg id from 10-sg bcoz in 10-sg only sg-id will be created
    tags = merge (
       local.common_tags,
        {
            Name = "${var.project}-${var.environment}-backend-alb"
        }
    )
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = module.alb.arn # taking the alb arn id in order to connect to alb
    port = "80"
    protocol = "HTTP"
    default_action {
        type = "fixed-response"
        fixed_response {
            content_type = "text/plain"
            message_body = "<h1>I'm From ALB</h1>"
            status_code  = "200"
        }
    }
}