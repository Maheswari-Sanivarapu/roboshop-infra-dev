## here calling the terraform-aws-vpc-module inorder to reuse the code
# here source is taking the code from terraform-aws-vpc-module in github
 
 ## input
 project (required)
 environment (required)


## output
we need VPC-ID so first module developer i.e. terraform-aws-vpc-module need to expose it in the same terraform-aws-vpc-module --> output.tf then only we will get that value from there we should call that value in main.tf by adding output in that way we will get vpc_id

10-sg needs the vpc_id as input so we are creating the ssm_parameter store in parameters.tf and storing the vpc_id in that ssm_parameter this will be stored in aws 

