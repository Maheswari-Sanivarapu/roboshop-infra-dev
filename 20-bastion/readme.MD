## here calling the terraform-aws-security-group-module and terraform-aws-vpc-module inorder to reuse the code
# here creating the resource for bastion host server
 
 ## input
 project (required)
 environment (required)
 public_subnet_id (mandatory) --> the bastion-host will be placed in public subnet so taking the public subnet id here and this value should be taken 00-vpc using data store where the public_subnet_id value is stored in ssm parameter store in aws
 sg_id (mandatory) --> in order to create bastion host/ec2 server sg_id is mandatory so creating the sg_id in 10-sg and allowing only ingress port i.e. ssh for the bastion_sg_id in order to connect from laptop in 10-sg

## output
20-bastion 
needs the sg_id and public_subnet_id as input so getting the sg_id and public_subnet_id as input using data source by calling the name of the ssm_parameter where the sg_id and public_subnet_id is stored in aws then using that sg_id and public_subnet_id as input here and we need only one public_subnet_id here to create bastion host

Getting the public_subnet_id exposed from terraform-aws-vpc-module --> output.tf 
Getting the sg_id exposed from terraform-aws-security-group-module --> output.tf 
using data.tf--> it will fetch the value of public_subnet_id and sg_id and storing that value in locals and calling it in main.tf



