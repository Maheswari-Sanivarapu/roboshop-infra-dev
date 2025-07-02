locals {
    ami_id = data.aws_ami.joindevops_ami.id
    private_subnet_id = split(",",data.aws_ssm_parameter.private_subnet_id.value)[0]
    private_subnet_ids = split(",",data.aws_ssm_parameter.private_subnet_id.value)
    catalogue_sg_id = data.aws_ssm_parameter.catalogue_sg_id.value
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    backend_alb_listener = data.aws_ssm_parameter.backend_alb_listener_arn.value
    common_tags = {
        project = var.project
        environment = var.environment
    }
}