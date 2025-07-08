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

## openvpn


## load balancer:
it should connection on ports from openvpn on port 22 and also from bastion on port 80 as incoming connection


## Databases
mongodb --> allowing ingress ports -->22(openvpn),27017
redis --> allowing ingress ports -->22(openvpn),6379
rabbitmq --> allowing ingress ports -->22(openvpn),5672
mysql --> allowing ingress ports -->22(openvpn),3306

--> storing the sg-ids of bastion,load balancer,openvpn,databases on ssm parameter store on aws

--> for load balancer the source_security_group_id is bastion and openvpn bcoz load balancer will be in private subnet and bastion,openvpn will be public subnet. if bastion is in private subnet then only openvpn is the source for lb

--> for databases(monogodb,redis,rabbitmq,mysql) source_security_group_id is openvpn sg-id

## catalogues:
creating the security group id for catalogue component using module and allowing the below incoming traffic to catalogue
1. catalogue_backend_alb (backend_alb to catalogue) --> catalogue should allow connection from backend_alb on port 8080. here backend_alb to catalogue so source_security_group_id is backend_alb and security_group_id is catalogue
2. catalogue_openvpn (openvpn to catalogue) --> catalogue show allow connection from vpn on port 22 in order to configure the catalogue component we should be connect to vpn then only we can do configuration in catalogue bcoz catalogue is in private subnet and it need public connection. here openvpn to catalogue so source_security_group_id is openvpn and security_group_id is catalogue
3. catalogue_bastion (bastion to catalogue) --> 22 to connect from bastion to catalague. here bastion to catalogue so source_security_group_id is bastion and security_group_id is catalogue
4. catalogue_vpn_http catalogue to vpn --> 8080 we can hit the url directly in the browser by using catalague to vpn connection and it will connect to application directly. here openvpn to catalogue so source_security_group_id is openvpn and security_group_id is catalogue
5. catalogue_mongodb --> here allowing the connection to mongodb from catalogue. bcoz in catalogue component we are connecting to mongodb. here catalogue to mongodb so source_security_group_id is catalogue and security_group_id is mongodb
--> here catalogue will accept connection from vpn and load balancer vpn ---> lb --->catalogue

              80                   8080                      
--> openvpn ------> load balancer -----> catalogue

same for other components as well like user,cart,payment,shipping

## user: it is dependent on mongodb and redis
1. mongodb_user --> user to monogodb -->monogodb show allow incoming connection from user on port 27017
2. user_redis --> user to redis --> redis show allow incoming connection from user on port 6379
3. user_bastion -->bastion to user -->22 to connect from bastion to user. here bastion to user so source_security_group_id is bastion and security_group_id is user
4. user_openvpn -->openvpn to user -->  user show allow connection from vpn on port 22 in order to configure the user component we should be connect to vpn then only we can do configuration in user bcoz user is in private subnet and it need public connection. here openvpn to user so source_security_group_id is openvpn and security_group_id is user
5. user_backend_alb --> backend_alb to user --> user should allow incoming connection from backend_alb on port 8080 .here backend_alb to user so source_security_group_id is backend_alb and security_group_id is user

## cart it is dependent on redis and catalogue

1. redis_cart --> cart to redis --> redis show allow incoming connection from cart on port 6379
2. cart_bastion -->bastion to cart -->22 to connect from bastion to cart. here bastion to cart so source_security_group_id is bastion and security_group_id is cart
3. cart_openvpn -->openvpn to cart -->  cart show allow connection from vpn on port 22 in order to configure the cart component we should be connect to vpn then only we can do configuration in cart bcoz cart is in private subnet and it need public connection. here openvpn to cart so source_security_group_id is openvpn and security_group_id is cart
4. cart_backend_alb --> backend_alb to cart --> cart should allow incoming connection from backend_alb on port 8080 .here backend_alb to user so source_security_group_id is backend_alb and security_group_id is cart
5. backend_alb_cart --> cart to backend_alb --> backend_alb show allow connection on port 80 from cart bcoz cart is having dependency on backend_alb in order to connect to catalogue so from   
       80                  8080
cart ----->  backend_alb -----> catalogue

## shipping component Dependent on cart and mysql
1. mysql_shipping --> shipping to mysql --> mysql show allow incoming connection from cart on port 3306
2. shipping_bastion -->bastion to shipping -->22 to connect from bastion to shipping. here bastion to shipping so source_security_group_id is bastion and security_group_id is shipping
3. shipping_openvpn -->openvpn to shipping --> shipping show allow connection from vpn on port 22 in order to configure the shipping component we should be connect to vpn then only we can do configuration in shipping bcoz shipping is in private subnet and it need public connection. here openvpn to shipping so source_security_group_id is openvpn and security_group_id is shipping
4. shipping_backend_alb --> backend_alb to shipping --> shipping should allow incoming connection from backend_alb on port 8080 .here backend_alb to shipping so source_security_group_id is backend_alb and security_group_id is shipping
5. backend_alb_shipping --> shipping to backend_alb --> backend_alb show allow connection on port 80 from shipping bcoz shipping is having dependency on backend_alb in order to connect to cart so from   
           80                 8080
shipping ----->  backend_alb -----> cart

## payment component Dependent on cart,user,rabbitmq
1. rabbitmq_payment --> payment to rabbitmq --> rabbitmq show allow incoming connection from payment on port 5672
2. payment_bastion -->bastion to payment -->22 to connect from bastion to payment. here bastion to payment so source_security_group_id is bastion and security_group_id is payment
3. payment_openvpn -->openvpn to payment --> payment show allow connection from vpn on port 22 in order to configure the payment component we should be connect to vpn then only we can do configuration in payment bcoz payment is in private subnet and it need public connection. here openvpn to payment so source_security_group_id is openvpn and security_group_id is payment
4. payment_backend_alb --> backend_alb to payment --> payment should allow incoming connection from backend_alb on port 8080 .here backend_alb to payment so source_security_group_id is backend_alb and security_group_id is payment
5. backend_alb_payment --> payment to backend_alb --> backend_alb show allow connection on port 80 from payment bcoz payment is having dependency on backend_alb in order to connect to cart,user so from   
          80                 8080
payment ----->  backend_alb -----> user,cart


## frontend component
1. frontend_frontend_alb ---> frontend_alb to frontend --> frontend show allow connction from frontent_alb on port 80
2. frontend_openvpn -->openvpn to frontend --> frontend show allow connection from vpn on port 22 in order to configure the frontend component we should be connect to vpn then only we can do configuration in frontend bcoz frontend is in private subnet and it need public connection. here openvpn to frontend so source_security_group_id is openvpn and security_group_id is frontend

## frontend_alb component
1. frontend_alb_https --> giving incoming traffic on port 443 on frontend_alb
2. frontend_alb_ssh --. giving incoming traffic on port 22 on frontend_alb

## backend_alb component
1. user_backend_alb --> backend_alb to user --> user should allow incoming connection from backend_alb on port 8080 .here backend_alb to user so source_security_group_id is backend_alb and security_group_id is user
2. cart_backend_alb --> backend_alb to cart --> cart should allow incoming connection from backend_alb on port 8080 .here backend_alb to user so source_security_group_id is backend_alb and security_group_id is cart
3. backend_alb_cart --> cart to backend_alb --> backend_alb show allow connection on port 80 from cart bcoz cart is having dependency on backend_alb in order to connect to catalogue 
4. shipping_backend_alb --> backend_alb to shipping --> shipping should allow incoming connection from backend_alb on port 8080 .here backend_alb to shipping so source_security_group_id is backend_alb and security_group_id is shipping
5. backend_alb_shipping --> shipping to backend_alb --> backend_alb show allow connection on port 80 from shipping bcoz shipping is having dependency on backend_alb in order to connect to cart
6. payment_backend_alb --> backend_alb to payment --> payment should allow incoming connection from backend_alb on port 8080 .here backend_alb to payment so source_security_group_id is backend_alb and security_group_id is payment
7. backend_alb_payment --> payment to backend_alb --> backend_alb show allow connection on port 80 from payment bcoz payment is having dependency on backend_alb in order to connect to cart,user
                                                                                                forward to 
                                                                     HTTPS                      dev.pavithra.fun
                                            HTTPS:443                 443                        targetgroup
when entering url https://dev.pavithra.fun  ----------> Frontend ALB ------> Frontend Listener -----------------> 
                                                                if /api/catalogue
                                                                in nginx.conf on                  HTTP
                            (dev.pavithra.fun)                      port 80                       8080
target group(dev.pavithra.fun)-------------> frontend component  ------------------> Backend ALB ------> Backend 

            forward it to
        catalogue.backend-dev.pavithra.fun                                                  8080
Listener --------------------------------> target group(catalogue.backend-dev.pavithra.fun) -----> catalogue component

same process for remaining components as well


--> from url if user hits dev.pavithra.fun then only it will forward to that dev.pavithra.fun or else it will won't forward it

troubleshooting:
1. First check security groups if all ports are allowed or not
2. check domain name in variables under ansible-roles
3. check host header rule inside listener
4. check target groups if instances in that or healthy or not
