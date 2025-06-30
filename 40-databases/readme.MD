## databases

## input
mongodb_sg_id,redis_sg_id,rabbitmq_sg_id,mysql_sg_id --> taking this values from 10-sg-id and allowing only ingress traffic for this security groups and making the source_security_group_id as openvpn-sg-id and these sg_id's values is kept in aws through ssm_parameter from there getting the value using data soure
database_private_subnet_id --> taking the value from 00-VPC and the value is kept in aws through ssm_parameter from there getting the value using data soure

-->first open connect to openvpn client software using openvpn server public ip bcoz we are in the same region where private subnet is places from there connecting to databases in private subnet
-->terraform_data is used here in order to connect to the instance and this terraform_data will not create any new resource it is just used to connect to that instance
--> provisioners is used here in order to perform below operations
    1.to copy the file bootstrap.sh from source to destination /tmp/bootstrap.sh and in that bootstrap.sh we are installing ansible and making the configuration management in this databases(mongodb,redis,mysql,rabbitmq) through ansible roles by pulling the code from github. use of this is instead of connecting to ansible everything we are using this bootstrap.sh file and pulling the ansible role from github
    so integrating terraform with ansible --> creating instances using terraform and configuring the required dependencies/libraries using ansible and by pulling the ansible roles from github
    2. to connect to that instance we are using connection here and passing the username,password,private ip to connect to that instance
    3. here using remote-exec provisioner to give permission to execute and install the databases(mongodb,mysql,rabbitmq,redis)