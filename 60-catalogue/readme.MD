# creating the target group


# creating the instance for catalogue component
## inputs 
security_group_id --> for catalogue component creating sg in 10-sg and this 10-sg it will store in ssm_parameter in aws from there calling it through data source
private_subnet_id --> for catalogue component private subnet id will be in 00-VPC and this 00-VPC will store it in ssm_parameter in aws from there calling it through data source
vpc_id --> here attaching the vpc_id to target group bcoz it requires vpc id


## target group
-->protocol in Target group is HTTP it is required to refer from load balancer
--> port 8080 is the port in order to connect to catalogue component
--> health check inside target group 

## catalogue instance
--> it requires ami_id to create instance so taking ami_id from data source
--> it need sg_id to create the catalogue instance taking this from 10-sg
--> it need private_subnet_id to create the instance taking this from 00-VPC
--> First installing the configurations in ansible using terraform_data

## steps to take AMI id of the catalogue instance
--> stopping the catalogue instance
--> taking the AMI ID from catalogue instance
--> terminating the catalogue instance using local-exec provisioner in Command Line 




