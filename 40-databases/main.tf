resource "aws_instance" "mongodb" {
    ami = local.ami_id
    instance_type = "t2.micro"
    vpc_security_group_ids = [local.mongodb_sg_id]
    subnet_id = local.database_subnet_id
    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-mongodb"
        }
    )
}

resource "terraform_data" "mongodb" { # terraform_Data is used to connect to specific instance and it won't create any new instance
    triggers_replace = [ 
        aws_instance.mongodb.id # once the instance is created we are connecting to that instance so here trigger replace will replace the mongo id with new value when there is a change
    ]

    connection { 
        type = "ssh"
        user = "ec2-user"
        password = "DevOps321"
        host = aws_instance.mongodb.private_ip # connecting to the created instance using private ip bcoz mongodb is present in private subnet
    }

    
    provisioner "file" {
        source = "bootstrap.sh" # here bootstrap.sh is used to create ansible and install the required files and here it is source
        destination = "/tmp/bootstrap.sh" # it will install dependencies in /tmp/bootstrap.sh
    }
    

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh mongodb ${var.environment}" # installing required dependencies
        ]
    }
}

#redis
resource "aws_instance" "redis" {
    ami = local.ami_id
    instance_type = "t2.micro"
    vpc_security_group_ids = [local.redis_sg_id]
    subnet_id = local.database_subnet_id
    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-redis"
        }
    )
}

resource "terraform_data" "redis" { 
    triggers_replace = [
        aws_instance.redis.id 
    ]

    connection {
        type = "ssh"
        user = "ec2-user"
        password = "DevOps321"
        host = aws_instance.redis.private_ip
    }

    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh redis ${var.environment}"
        ]
    }
}


#mysql
resource "aws_instance" "mysql" {
    ami = local.ami_id
    instance_type = "t2.micro"
    vpc_security_group_ids = [local.mysql_sg_id]
    subnet_id = local.database_subnet_id
    iam_instance_profile = "EC2toFetchSSMParametee" # this IAM role is used to fetch the Mysql password from ssm parameter store in aws,
#so creating IAM Role with ec2 service to connect to ssm parameter to fetch mysql password and attaching this role to MYSQL EC2 Instance and this EC2 instance will take password from aws
    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-mysql"
        }
    )
}

resource "terraform_data" "mysql" {
    triggers_replace = [
        aws_instance.mysql.id
    ]

    connection {
        type = "ssh"
        user = "ec2-user"
        password = "DevOps321"
        host = aws_instance.mysql.private_ip
    }

    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh mysql ${var.environment}"
        ]
    }
}

#rabbitmq
resource "aws_instance" "rabbitmq" {
    ami = local.ami_id
    instance_type = "t2.micro"
    vpc_security_group_ids = [local.rabbitmq_sg_id]
    subnet_id = local.database_subnet_id
    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-rabbitmq"
        }
    )
}

resource "terraform_data" "rabbitmq" {
    triggers_replace = [
        aws_instance.rabbitmq.id
    ]

    connection { # here connecting to the ec2 instance
        type = "ssh"
        user = "ec2-user"
        password = "DevOps321"
        host = aws_instance.rabbitmq.private_ip
    }

    provisioner "file" { # after connecting to instance copying the file from source to destination
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }
    
    provisioner "remote-exec" { # then executing the file on remote instance i.e. ec2 instance
        inline = [
            "chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh rabbitmq ${var.environment}"
        ]
    }
}


# storing mongodb private-ip in route53  
#name = mongodb-roboshop.pavithra.fun
resource "aws_route53_record" "mongodb" {
  zone_id = var.route53_zone_id
  name    = "mongodb-${var.environment}.${var.route53_domain_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.mongodb.private_ip]
  allow_overwrite = true
}

# storing redis private-ip in route53
#name = redis-roboshop.pavithra.fun
resource "aws_route53_record" "redis" {
    zone_id = var.route53_zone_id
    name = "redis-${var.environment}.${var.route53_domain_name}"
    type = "A"
    ttl = 1
    records = [aws_instance.redis.private_ip]
    allow_overwrite = true
}

# storing mysql private-ip in route53
#name = mysql-roboshop.pavithra.fun
resource "aws_route53_record" "mysql" {
    zone_id = var.route53_zone_id
    name = "mysql-${var.environment}.${var.route53_domain_name}"
    type = "A"
    ttl = 1
    records = [aws_instance.mysql.private_ip]
    allow_overwrite = true
}

# storing rabbitmq private-ip in route53
#name = rabbitmq-roboshop.pavithra.fun
resource "aws_route53_record" "rabbitmq" {
    zone_id = var.route53_zone_id
    name = "rabbitmq-${var.environment}.${var.route53_domain_name}"
    type = "A"
    ttl = 1
    records = [aws_instance.rabbitmq.private_ip]
    allow_overwrite = true
}