#roboshop-dev-backend-alb
module "backend_alb" {
    source = "terraform-aws-modules/alb/aws" # teking the module from terraform_aws_alb documentation
    version = "9.16.0" # giving the version from terraform_aws_alb bcoz in provider version is diff and here it is diff to make compatible adding that module specific version here so either change version in provider or specify version here
    internal = true # means this load balancer will be create in private subnet only. internal = false means it will create in public subnet
    name = "${var.project}-${var.environment}-backend-alb"
    vpc_id = local.vpc_id
    subnets = local.private_subnet_ids # creating the alb in private subnet bcoz this is for backend and backend should be in private subnet
    create_security_group = false
    security_groups = [local.backend_alb_sg_id]  # getting the backend sg id from 10-sg bcoz in 10-sg only sg-id will be created
    enable_deletion_protection = false
    tags = merge (
       local.common_tags,
        {
            Name = "${var.project}-${var.environment}-backend-alb"
        }
    )
}

# creating the listener and attaching it to alb
resource "aws_lb_listener" "backend_alb_listener" {
    load_balancer_arn = module.backend_alb.arn # taking the alb arn id in order to connect to alb
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

#creating the route53 for load balancer bcoz here lb is having big DNS Name so adding the DNS Name in route53 record
resource "aws_route53_record" "loadbalancer" {
  zone_id = var.route53_zone_id # take zone id from route53
  name    = "*.backend-${var.environment}.${var.route53_domain_name}" # take domain name from route53
  type    = "A"
  allow_overwrite = true
  alias {
    name                   = module.alb.dns_name # dns_name of ALB storing it in route53 in aws
    zone_id                = module.alb.zone_id # zone id of ALB
    evaluate_target_health = true
  }
}