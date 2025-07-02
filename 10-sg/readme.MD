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


--> Here Creating the security groups for bastion server/ec2-instance,load balancer(allowing sg-id of bastion and openvpn),openvpn(allowing only ingress ports on 22,443,1194,943),databases(monogodb,redis,rabbitmq,mysql)
mongodb --> allowing ingress ports -->22(openvpn),27017
redis --> allowing ingress ports -->22(openvpn),6379
rabbitmq --> allowing ingress ports -->22(openvpn),5672
mysql --> allowing ingress ports -->22(openvpn),3306

--> storing the sg-ids of bastion,load balancer,openvpn,databases on ssm parameter store on aws

--> for load balancer the source_security_group_id is bastion and openvpn bcoz load balancer will be in private subnet and bastion,openvpn will be public subnet. if bastion is in private subnet then only openvpn is the source for lb

--> for databases(monogodb,redis,rabbitmq,mysql) source_security_group_id is openvpn sg-id

catalogue:
creating the security group id for catalogue component using module and allowing the below incoming traffic to catalogue
1. catalogue_backend_alb (backend_alb to catalogue) --> catalogue should allow connection from backend_alb on port 8080. here backend_alb to catalogue so source_security_group_id is backend_alb and security_group_id is catalogue
2. catalogue_openvpn (openvpn to catalogue) --> catalogue show allow connection from vpn on port 22 in order to configure the component in catalogue we should be connect to vpn then only we can do configuration in catalogue bcoz catalogue is in private subnet and it need public connection. here openvpn to catalogue so source_security_group_id is openvpn and security_group_id is catalogue
3. catalogue_bastion (bastion to catalogue) --> 22 to connect from bastion to catalague. here bastion to catalogue so source_security_group_id is bastion and security_group_id is catalogue
4. catalogue_vpn_http catalogue to vpn --> 8080 we can hit the url directly in the browser by using catalague to vpn connection and it will connect to application directly. here openvpn to catalogue so source_security_group_id is openvpn and security_group_id is catalogue
5. catalogue_mongodb --> here allowing the connection to mongodb from catalogue. bcoz in catalogue component we are connecting to mongodb. here catalogue to mongodb so source_security_group_id is catalogue and security_group_id is mongodb
--> here catalogue will accept connection from vpn and load balancer vpn ---> lb --->catalogue