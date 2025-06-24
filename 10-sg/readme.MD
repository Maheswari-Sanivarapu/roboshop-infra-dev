## here calling the terraform-aws-security-group-module inorder to reuse the code
# here source is taking the code terraform-aws-security-group-module in github
 
 ## input
 project (required)
 environment (required)


## output
Getting the VPC-ID exposed from terraform-aws-vpc-module --> output.tf 
using data.tf--> it will fetch the value of vpc_id and storing that value in locals and calling it in main.tf

after getting the security group id it will store that security group id  in aws_ssm_parameter store by creating the aws_ssm_parameter store in parameters.tf and it will this as input to instance
