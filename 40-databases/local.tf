locals {
    ami_id = data.ami_id.databases_ami
    database_subnet_id = data.aws_ssm_parameter.database_subnet_id
    mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id
    redis_sg_id = data.aws_ssm_parameter.redis_sg_id
    mysql_sg_id = data.aws_ssm_parameter.mysql_sg_id
    rabbitmq_sg_id = data.aws_ssm_parameter.rabbitmq_sg_id
} 