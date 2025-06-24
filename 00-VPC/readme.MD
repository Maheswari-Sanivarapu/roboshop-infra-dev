## here calling the terraform-aws-vpc-module inorder to reuse the code
# here source is taking the code from terraform-aws-vpc-module in github
 
 ## input
 project (required)
 environment (required)


## output
Getting the VPC-ID exposed from terraform-aws-vpc-module --> output.tf
and storing the vpc-id in aws_ssm_parameter store by creating the aws_ssm_parameter store in parameters.tf and it will this as input to security group
