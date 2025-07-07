module "frontend_alb" {
    source = "terraform-aws-modules/alb/aws" # teking the module from terraform_aws_alb documentation
    version = "9.16.0" # giving the version from terraform_aws_alb bcoz in provider version is diff and here it is diff to make compatible adding that module specific version here so either change version in provider or specify version here
    internal = false
    name = "${var.project}-${var.environment}-frontend-alb"
    subnets = local.public_subnet_ids
    vpc_id = local.vpc_id
    create_security_group = false
    security_groups = [local.frontend_alb]
    enable_deletion_protection = false
    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-frontend-alb"
        }
    )
}

resource "aws_lb_listener" "frontend_alb_listener" {
    load_balancer_arn  = module.frontend_alb.arn
    port = "443"
    protocol = "HTTPS"
    ssl_policy        = "ELBSecurityPolicy-2016-08"
    certificate_arn   = local.acm_certificate_arn
     default_action {
        type = "fixed-response"
        fixed_response {
            content_type = "text/plain"
            message_body = "<h1>Hi,I'm From Frontend ALB</h1>"
            status_code  = "200"
        }
    }
}

resource "aws_route53_record" "route53_frontend_alb" {
    zone_id = var.route53_zone_id
    name = "*.${var.route53_domain_name}" # *.pavithra.fun
    type = "A"
    alias {
     name = module.frontend_alb.dns_name
     zone_id = module.frontend_alb.zone_id  # zone-id of ALB
     evaluate_target_health = true
    }
}