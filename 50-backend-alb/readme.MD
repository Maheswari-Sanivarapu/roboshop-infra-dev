## Load Balancer
It will distribute the load to different based on request received through listener
Here keeping the load balancer in Private subnet

## input
sg-id --> creating the sg-id for the load balancer in 10-sg the 10-sg will store load balancer sg-id in aws and from aws getting the load balancer sg-id through data source 
private-subnet-id --> creating the prviate subnet id in 00-VPC the 00-VPC will store the private subnet id's in aws and from aws getting the private subnet id's through data source 

