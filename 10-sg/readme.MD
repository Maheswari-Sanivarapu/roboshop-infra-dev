## here calling the terraform-aws-security-group-module inorder to reuse the code
# here source is taking the code terraform-aws-security-group-module in github
 
 ## inputs
 project (required)
 environment (required)
 vpc_id (mandatory) --> it should be taken from 00-vpc where it is stored in ssm_parameter store in aws

## output
10-sg needs the vpc_id as input so getting the vpc_id as input using data source by calling the name of the ssm_parameter where the vpc id is stored in aws then using that vpc_id as input here 

Getting the VPC-ID exposed from terraform-aws-vpc-module --> output.tf 
using data.tf--> it will fetch the value of vpc_id and storing that value in locals and calling it in main.tf

after getting the security group id it will store that security group id  in aws_ssm_parameter store by creating the aws_ssm_parameter store in parameters.tf and it will this as input to instances


