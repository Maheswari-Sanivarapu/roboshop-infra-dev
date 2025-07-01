resource "aws_lb_target_group" "catalogue" {
    name = "${var.project}-${var.environment}-catalogue"
    port = 8080 # here for catalogue  port 8080 will be allowed here backend component runs on port 8080
    protocol = "HTTP"
    vpc_id = local.vpc_id
    health_check {
        healthy_threshold = 2 #Number of consecutive health check successes required before considering a target healthy. The range is 2-10. Defaults to 3.
        interval = 5 # Approximate amount of time, in seconds, between health checks of an individual target. The range is 5-300
        matcher = "200-299" # response code for health check it ranges from 200-299
        path = "/health" # checking the health of the catalogue component
        port = 8080 # port which catalogue component is allowed
        timeout = 5 # after hitting the URL before 5 seconds we should get response or it is unhealthy
        unhealthy_threshold = 3 # to check the health of the instane we will use this if the instance fails after 3 attempts then it will mark it as unhealthy
    }   
}

resource "aws_instance" "catalogue" {
    ami = local.ami_id
    instance_type = "t2.micro"
    vpc_security_group_ids = [local.catalogue_sg_id]
    subnet_id = [local.private_subnet_id]
    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-catalogue"
        }
    )
}


resource "terraform_data" "catalgoue" {
    triggers_replace = {
        aws_instance.catalogue.id
    }

    provisioner "file" {
        source = "catalogue.sh"
        destination = "/tmp/catalogue.sh"
    }

    connection {
        type = "ssh"
        user = "ec2-user"
        password = "DevOps321"
        host = aws_instance.catalogue.private_ip
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/catalogue.sh",
            "sudo sh /tmp/catalogue.sh catalogue"
        ]
    }
}

resource "aws_route53_record" "catalogue" {
    zone_id = var.route53_zone_id
    name = "catalogue-${var.environment}.${var.route53_domain_name}"
    type = "A"
    ttl = 1
    records = [aws_instance.catalgoue.private_ip]
    allow_overwrite = true
}
