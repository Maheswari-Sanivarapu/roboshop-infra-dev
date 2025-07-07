module "frontend" {
    #source = "../../terraform-aws-security-group-module"
    source = "git::https://github.com/mahi2298/terraform-aws-security-group-module.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.frontend_sg_name
    sg_description = var.frontend_sg_description
    vpc_id = local.vpc_id # retrieving the vpc id using data source and calling that value here
}

# here we are storing this value in ssm parameter store i.e. in parameters.tf
output "sg_id" {
    value = module.frontend.sg_id # here .sg_id is exposed from output of terraform-aws-security-group-module
}

# creating the security group for bastion server
module "bastion" {
    source = "git::https://github.com/mahi2298/terraform-aws-security-group-module.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = var.bastion_sg_name
    sg_description = var.bastion_sg_description
    vpc_id = local.vpc_id
}

# creating security group for application load balancer
module "backend_alb" {
    source = "git::https://github.com/mahi2298/terraform-aws-security-group-module.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "backend-alb"
    sg_description = "backend-application-load-balancer"
    vpc_id = local.vpc_id
}

module "frontend_alb" {
    source = "git::https://github.com/mahi2298/terraform-aws-security-group-module.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "frontend-alb"
    sg_description = "frontend-application-load-balancer"
    vpc_id = local.vpc_id
}

module "openvpn" {
    source ="git::https://github.com/mahi2298/terraform-aws-security-group-module.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "openvpn"
    sg_description = "for openvpn connection"
    vpc_id = local.vpc_id
}

module "mongodb" {
    source ="git::https://github.com/mahi2298/terraform-aws-security-group-module.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "mongodb"
    sg_description = "for mongodb connection"
    vpc_id = local.vpc_id
}

module "redis" {
    source ="git::https://github.com/mahi2298/terraform-aws-security-group-module.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "redis"
    sg_description = "for redis connection"
    vpc_id = local.vpc_id
}

module "mysql" {
    source ="git::https://github.com/mahi2298/terraform-aws-security-group-module.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "mysql"
    sg_description = "for mysql connection"
    vpc_id = local.vpc_id
}

module "rabbitmq" {
    source ="git::https://github.com/mahi2298/terraform-aws-security-group-module.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "rabbitmq"
    sg_description = "for rabbitmq connection"
    vpc_id = local.vpc_id
}

module "catalogue" {
    source = "git::https://github.com/mahi2298/terraform-aws-security-group-module.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "catalogue"
    sg_description = "for catalogue connection"
    vpc_id = local.vpc_id
}

module "user" {
    source = "git::https://github.com/mahi2298/terraform-aws-security-group-module.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "user"
    sg_description = "for user connection"
    vpc_id = local.vpc_id
}

module "cart" {
    source = "git::https://github.com/mahi2298/terraform-aws-security-group-module.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "cart"
    sg_description = "for cart connection"
    vpc_id = local.vpc_id
}

module "shipping" {
    source = "git::https://github.com/mahi2298/terraform-aws-security-group-module.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "shipping"
    sg_description = "for shipping connection"
    vpc_id = local.vpc_id
}

module "payment" {
    source = "git::https://github.com/mahi2298/terraform-aws-security-group-module.git?ref=main"
    project = var.project
    environment = var.environment
    sg_name = "payment"
    sg_description = "for payment connection"
    vpc_id = local.vpc_id
}

# giving connection from laptop to bastion by creating the security group for basiton and allowing only incoming traffic on port 22 for bastion
resource "aws_security_group_rule" "bastion_laptop" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.bastion.sg_id
}

# giving connection from bastion to alb by creating the security group for backend-alb and allowing only port 80 and also sg-id of bastion to alb as the incoming traffic
# bcoz for load balancer incoming traffic of port 80 only will be allowed in order to get trrafic from outside we are using the sg-id of bastion bcoz this bastion will be in public subnet 
# from laptop --> bastion server (created in public subnet) --> load balancer (created in private subnet)
resource "aws_security_group_rule" "backend_alb_bastion" {
    type = "ingress" 
    from_port = 80 # allowing port 80 as incoming traffic
    to_port = 80 # allowing port 80 as incoming traffic
    protocol = "tcp"
    source_security_group_id = module.bastion.sg_id # taking the sg id of bastion and attaching it to to backend-alb as incoming traffic
    security_group_id = module.backend_alb.sg_id # backend-alb security id
}

# making the connection from load balancer to openvpn in order to make the connection
resource "aws_security_group_rule" "backend_alb_openvpn" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    source_security_group_id = module.openvpn.sg_id # attaching the openvpn sg_id to load balancer to make connection between load balancer and openvpn
    # if user connects to openvpn client and user is in that region he will directly to the load balancer through DNS Name
    security_group_id = module.backend_alb.sg_id # load balancer security group id
}

#vpn ports are 22,443,1194,943
resource "aws_security_group_rule" "vpn_ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.openvpn.sg_id
}

resource "aws_security_group_rule" "vpn_https" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.openvpn.sg_id
}

resource "aws_security_group_rule" "vpn_1194" {
    type = "ingress"
    from_port = 1194
    to_port = 1194
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.openvpn.sg_id
}

resource "aws_security_group_rule" "vpn_943" {
    type = "ingress"
    from_port = 943
    to_port = 943
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.openvpn.sg_id
}

#mongodb port from openvpn
resource "aws_security_group_rule" "mongodb_ports_vpn" {
    count = length(var.mongodb_ports_vpn)
    type = "ingress"
    from_port = var.mongodb_ports_vpn[count.index]
    to_port = var.mongodb_ports_vpn[count.index]
    protocol = "tcp"
    source_security_group_id = module.openvpn.sg_id
    security_group_id = module.mongodb.sg_id
}

#redis ports from openvpn
resource "aws_security_group_rule" "redis_ports_vpn" {
    count = length(var.redis_ports_vpn)
    type = "ingress"
    from_port = var.redis_ports_vpn[count.index]
    to_port = var.redis_ports_vpn[count.index]
    protocol = "tcp"
    source_security_group_id = module.openvpn.sg_id
    security_group_id = module.redis.sg_id
}

#mysql ports from openvpn
resource "aws_security_group_rule" "mysql_ports_vpn" {
    count = length(var.mysql_ports_vpn)
    type = "ingress"
    from_port = var.mysql_ports_vpn[count.index]
    to_port = var.mysql_ports_vpn[count.index]
    protocol = "tcp"
    source_security_group_id = module.openvpn.sg_id
    security_group_id = module.mysql.sg_id
}

#rabbitmq ports from openvpn
resource "aws_security_group_rule" "rabbitmq_ports_vpn" {
    count = length(var.rabbitmq_ports_vpn)
    type = "ingress"
    from_port = var.rabbitmq_ports_vpn[count.index]
    to_port = var.rabbitmq_ports_vpn[count.index]
    protocol = "tcp"
    source_security_group_id = module.openvpn.sg_id
    security_group_id = module.rabbitmq.sg_id
}


#catalogue ports 
#alb to catalogue port 8080
resource "aws_security_group_rule" "backend_alb_catalogue" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    source_security_group_id = module.backend_alb.sg_id
    security_group_id = module.catalogue.sg_id
}

#openvpn to catalogue ssh port 22
resource "aws_security_group_rule" "catalogue_openvpn_ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = module.openvpn.sg_id
    security_group_id = module.catalogue.sg_id
}

#openvpn to catalogue http port directly on 8080
resource "aws_security_group_rule" "catalogue_openvpn_ssh" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    source_security_group_id = module.openvpn.sg_id
    security_group_id = module.catalogue.sg_id
}

#bastion to catalogue on port 22
resource "aws_security_group_rule" "bastion_catalogue" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = module.bastion.sg_id
    security_group_id = module.catalogue.sg_id
}

# catalogue to mongodb on port 27017
resource "aws_security_group_rule" "catalogue_mongodb" {
    type = "ingress"
    from_port = 27017
    to_port = 27017
    protocol = "tcp"
    source_security_group_id = module.catalogue.sg_id
    security_group_id = module.mongodb.sg_id
}

# frontend_alb on http port
resource "aws_security_group_rule" "frontend_alb_http" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.frontend_alb.sg_id
}

# frontend_alb on https port
resource "aws_security_group_rule" "frontend_alb_https" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = module.frontend_alb.sg_id
}

# frontend_alb to frontend
resource "aws_security_group_rule" "frontend_frontend_alb" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    source_security_group_id = module.frontend_alb.sg_id
    security_group_id = module.frontend.sg_id
}

# openvpn to frontend
resource "aws_security_group_rule" "frontend_openvpn" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = module.openvpn.sg_id
    security_group_id = module.frontend.sg_id
}

#user component
# user component Dependent on mongodb and redis
# user to mongodb 
resource "aws_security_group_rule" "mongodb_user" {
    type = "ingress"
    from_port = 27017
    to_port = 27017
    protocol = "tcp"
    source_security_group_id = module.user.sg_id
    security_group_id = module.mongodb.sg_id
}

# user to redis on 6379
resource "aws_security_group_rule" "redis_user" {
    type = "ingress"
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    source_security_group_id = module.user.sg_id
    security_group_id = module.redis.sg_id
}

# openvpn to user on port 22 to configure user component
resource "aws_security_group_rule" "user_openvpn_ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = module.openvpn.sg_id
    security_group_id = module.user.sg_id
}

# openvpn to user on port 8080 to connect directly to user component
resource "aws_security_group_rule" "user_openvpn_http" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    source_security_group_id = module.openvpn.sg_id
    security_group_id = module.user.sg_id
}


# cart component 
# cart component Dependent on redis and catalogue
# cart to redis on 6379
resource "aws_security_group_rule" "redis_cart"{
    type = "ingress"
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    source_security_group_id = module.cart.sg_id
    security_group_id = module.redis.sg_id
}


# openvpn to cart on port 8080 to connect directly to cart component
resource "aws_security_group_rule" "cart_openvpn_http" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    source_security_group_id = module.openvpn.sg_id
    security_group_id = module.cart.sg_id
}

# openvpn to cart on port 22 to configure the cart component
resource "aws_security_group_rule" "cart_openvpn_ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = module.openvpn.sg_id
    security_group_id = module.cart.sg_id
}

# backend_alb to cart component on 8080
resource "aws_security_group_rule" "cart_backend_alb" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    source_security_group_id = module.backend_alb.sg_id
    security_group_id = module.cart.sg_id
}

# cart to backend_alb on port 80 and then backend_alb to catalogue on port 8080
resource "aws_security_group_rule" "backend_alb_cart" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    source_security_group_id = module.cart.sg_id
    security_group_id = module.backend_alb.sg_id
}

#shipping component
# shipping component Dependent on cart and mysql
# shipping to mysql on port 3306 bcoz shipping is dependent on mysql
resource "aws_security_group_rule" "mysql_shipping" {
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    source_security_group_id = module.shipping.sg_id
    security_group_id = module.mysql.sg_id
}

# shipping to backend_alb on port 80 and then from backend_alb to cart on port 8080
resource "aws_security_group_rule" "backend_alb_shipping" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    source_security_group_id = module.shipping.sg_id
    security_group_id = module.backend_alb.sg_id
}

# backend_alb to shipping to on port 8080 
resource "aws_security_group_rule" "backend_alb_shipping" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    source_security_group_id = module.backend_alb.sg_id
    security_group_id = module.shipping.sg_id
}

# openvpn to shipping on port 8080 to connect directly to shipping component
resource "aws_security_group_rule" "cart_openvpn_http" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    source_security_group_id = module.openvpn.sg_id
    security_group_id = module.shipping.sg_id
}

# openvpn to shipping on port 22  to configure the shipping component
resource "aws_security_group_rule" "shipping_openvpn_ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = module.openvpn.sg_id
    security_group_id = module.shipping.sg_id
}

#payment component
# payment component is dependent on cart,user,rabbitmq
#payment to rabbitmq on port 5672
resource "aws_security_group_rule" "rabbitmq_payment" {
    type = "ingress"
    from_port = 5672
    to_port = 5672
    protocol = "tcp"
    source_security_group_id = module.payment.sg_id
    security_group_id = module.rabbitmq.sg_id
}

# openvpn to shipping on port 8080 to connect directly to payment component
resource "aws_security_group_rule" "payment_openvpn_http" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    source_security_group_id = module.openvpn.sg_id
    security_group_id = module.payment.sg_id
}

# openvpn to shipping on port 22 directly to configure the payment component
resource "aws_security_group_rule" "payment_openvpn_ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = module.openvpn.sg_id
    security_group_id = module.payment.sg_id
}

# backend_alb to payment on port 8080
resource "aws_security_group_rule" "payment_backend_alb" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    source_security_group_id = module.backend_alb.sg_id
    security_group_id = module.payment.sg_id
}

#payment to backend_alb on port 80 and then from backend_alb to payment on port 8080
resource "aws_security_group_rule" "backend_alb_payment" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    source_security_group_id = module.payment.sg_id
    security_group_id = module.backend_alb.sg_id
}
