locals {
    public_subnet_ids = split(",",data.aws_ssm_parameter.public_subnet_id.value)
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    frontend_alb = data.aws_ssm_parameter.frontend_alb_sg_id.value
    acm_certificate_arn = data.aws_ssm_parameter.acm_certificate_arn.value
    common_tags = {
        project = var.project
        environment = var.environment
    }
}