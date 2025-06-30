## Openvpn
creating the open vpn server and logging into that openvpn server/ec2 instance through openvpn client using this openvpn we can connect to different and access the content so here we are connecting to us-east-1 region for now

## inputs
sg-id --> it will get the sg-id for openvpn through 10-sg and this 10-sg will store it in ssm_parameter store in aws from there it willg get the sg-id using data source
public_subnet_id --> it will the public_subnet_id through 00-VPC and this public_subnet_id will store it in ssm_parameter store in aws from there it willg get the public_subnet_id using data source
key-pair --> importing the key pair from local folder with that specific path
open_vpn_ami_id taking the ami_id from aws for openvpn server



--> here storing the setup related to openvpn in openvpn.sh in order to connect to openvpn server
--> in order to connect to private subnets like load balancer, databases we need to first connect to openvpn client through openvpn server/ec2 instance public instance than we can connect to databases and load balancer automatically bcoz in 10-sg we have given the openvpn-sg-id as source_security_group to DB and lb so that it will work