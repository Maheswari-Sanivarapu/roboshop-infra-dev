locals {
    acm_certificate = data.aws_ssm_parameter.acm_certificate_arn.value
    common_tags = {
        project = var.project
        environment = var.environment
        Terraform = "true"
    }
}