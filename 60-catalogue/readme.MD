# creating the target group
HTTP is the protocol from backend_alb to catalogue and catalogue allows port 8080
/health --> to check the health of backend components
/ --> to check the health of frontend components
vpc_id --> it is required


# creating the instance for catalogue component
## inputs 
security_group_id --> for catalogue component creating sg in 10-sg and this 10-sg it will store in ssm_parameter in aws from there calling it through data source
private_subnet_id --> for catalogue component private subnet id will be in 00-VPC and this 00-VPC will store it in ssm_parameter in aws from there calling it through data source
vpc_id --> here attaching the vpc_id to target group bcoz it requires vpc id

VPN hits ALB (on Port 80) --> ALB forwards the request to Catalogue (on Port 8080) ---> Catalogue must allow port 8080 from ALB SG

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
-->Once the AMI ID is taken do launch template using that AMI-id and pass image-id of the deleted instance,instance_type,name,sg-id of instance,instance_initiated_shutdown_behavior like stop or terminate, tags_specification to create instance and volume is attached to the instance add it under tags_specification,resource_type is instance
--> Create autoscaling group --> it requires desired_capacity, min_size,max_size,health_check_grace_period,availability_zones,launch_template,delete,auto-refresh when new launch_template is taken. here specifying the max and min size to increase/decrease instances and adding the instance to target group
--> Create autoscaling policy and attach it to autoscaling group --> autoscaling group name,policy_type,target_tracking
--> Add rule in Listener --> listener arn,condition(when certain condition is met),then action(forward to target group)
--> Here creating the target group but not adding the instance to it,so here we are creating the autoscaling group and attaching the target group and instance to it. based on the demand the autoscaling will increase/decrease the load
---> create autoscaling policy :- based on this autoscale policy only it will autoscale the instances, if suppose cpu utilization is more than 75 then it will increase the load



## After Accessing the URL
Launch template --> Autoscaling group --> LB --> Listener --> target group --> instance
--> first traffic routes from LB only, when user hits url like http://catalogue.backend-dev.pavithra.fun then this request will go to load balancer and here Lb will listener based on the protocol i.e. HTTP or HTTPS and listener is having rule like when getting the above url http://catalogue.backend-dev.pavithra.fun forward to target group catalogue, if cpu utilization is high then it will autoscale automatically bcoz autoscaling is attached with load balancer and instance


--> here trigger_replace is used whenever there is change in instance-id this trigger_replace will refresh with new instance-id and ask provisioner to do configuration with this new instance id 



## to run specific component we can use this
terraform plan -target='module.component["catalogue"]'
terraform apply -target='module.component["catalogue"]'


Quiz Questions:-
# what is the purpose of null_resource provisioner in terraform ?
To Run local scripts  ( it is used to plan and run the local/remote scripts and it won't create any new resource in terraform)

## How can you stop ec2 instance in terraform?
by changing instance state to stopped and it don't have stop_instance

## what does autoscaling group do in terraform?
it automates instance scaling

## How do you connect to 2 VPCS?
VPC Peering with diff CIDR

## How do you create an HTTPS Listener in terraform?
resource "aws_lb_listener" (based on the ports opened it will decide wheather it is HTTP or HTTPS)

## What is a frontend component in terraform?
ELB Listener ( from ELB Listener --> Frontend component)

## how do you get existing info from provider?
using data source

## what is listener rule in terraform?
routing rule (bcoz it routes the request to specific target group)

## in terraform while defining VPC in AWS, which of the following CIDR blocks Provides largest number of available IP addresses?
10.0.0.0/24
10.0.0.0/16 --> this will provide less IP addresses
172.31.0.0/20
192.68.0.0/18

## what should be a basic VPC Module include?
VPC,subnets,route tables and internet gateway

## what is an Internet Gateway in AWS?
A resource to allow VPC communication with the internet

## When module developers update it how to get updates?
terraform init -upgrade


