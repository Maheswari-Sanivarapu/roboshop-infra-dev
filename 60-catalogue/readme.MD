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
-->Once the AMI ID is taken do launch template using that AMI-id and pass image-id of the deleted instance,instance_type,name,sg-id of instance,instance_initiated_shutdown_behavior like stop or terminate, tags_specification to create instance and volume is attached to the instance add it under tags_specification,resource_type is instance
--> Create autoscaling group --> it requires desired_capacity, min_size,max_size,health_check_grace_period,availability_zones,launch_template,delete,auto-refresh when new launch_template is taken
--> Create autoscaling policy and attach it to autoscaling group --> autoscaling group name,policy_type,target_tracking
--> Add rule in Listener --> listener arn,condition(when certain condition is met),then action(forward to target group),


Launch template --> Autoscaling group --> LB --> Listener --> target group --> instance
--> first traffic routes from LB only, when user hits url like http://catalogue.backend-dev.pavithra.fun then this request will go to load balancer and here Lb will listener based on the protocol i.e. HTTP or HTTPS and listener is having rule like when getting the above url http://catalogue.backend-dev.pavithra.fun forward to target group catalogue, if cpu utilization is high then it will autoscale automatically bcoz autoscaling is attached with load balancer and instance


--> here trigger_replace is used whenever there is change in instance-id this trigger_replace will refresh with new instance-id and ask provisioner to do configuration with this new instance id 