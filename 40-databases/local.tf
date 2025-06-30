locals {
    ami_id = data.aws_ami.databases_ami.id
    database_subnet_id = data.aws_ssm_parameter.database_subnet_id.value
    mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id.value
    redis_sg_id = data.aws_ssm_parameter.redis_sg_id.value
    mysql_sg_id = data.aws_ssm_parameter.mysql_sg_id.value
    rabbitmq_sg_id = data.aws_ssm_parameter.rabbitmq_sg_id.value
    common_tags = {
        project = var.project
        environment = var.environment
    }
} 