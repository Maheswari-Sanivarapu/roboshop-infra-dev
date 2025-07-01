# creating the target group


# creating the instance for catalogue component
## inputs 
security_group_id --> for catalogue component creating sg in 10-sg and this 10-sg it will store in ssm_parameter in aws from there calling it through data source
private_subnet_id --> for catalogue component private subnet id will be in 00-VPC and this 00-VPC will store it in ssm_parameter in aws from there calling it through data source
vpc_id --> here attaching the vpc_id to target group bcoz it requires vpc id
