## Load Balancer
It will distribute the load to different based on request received through listener
Here keeping the load balancer in Private subnet



## input
sg-id --> creating the sg-id for the load balancer in 10-sg the 10-sg will store load balancer sg-id in aws and from aws getting the load balancer sg-id through data source 
private-subnet-id --> creating the prviate subnet id in 00-VPC the 00-VPC will store the private subnet id's in aws and from aws getting the private subnet id's through data source 

creating the load balancer with sg-id and private subnet-id

## output
getting load balancer arn and giving it as input to listener



--> Here creating the load balancer and attaching load balancer arn to listener
--> in order to access the application inside load balancer we are connecting the bastion sg-id to load balancer by allowing only ingress traffic and also connecting the openvpn sg-id to load balancer by allowing only ingress traffic 
--> allowing ingress traffic to lb using source_security_group_id as bastion server sg-id and openvpn sg-id

--> creating the route53 record for load balancer bcoz dns name of route53 is too long
    creating the record with alias
    taking the zone-id and name taking it from route53 in aws
    taking the zone-id and name inside alias from newly created load balancer

for frontend-alb --> 443,HTTPS
frontend component --> 80,HTTP
for backend-alb -->80
for backend component --> 80

everything from frontend component is HTTP only and it is internal and only frontend_alb is HTTPS
