resource "aws_cloudfront_distribution" "roboshop" {
    origin {
        domain_name = "cdn.${var.route53_domain_name}" # cdn.pavithra.fun here it is cdn domain name
        custom_origin_config {
            http_port              = 80
            https_port             = 443
            origin_protocol_policy = "https-only"
            origin_ssl_protocols   = ["TLSv1.2"]
    }
    origin_id = "dev.${var.route53_domain_name}" # frontend_alb domain name
    }
    enabled = true
    aliases = ["cdn.${var.route53_domain_name}"]

    default_cache_behavior {
        allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = "*.${var.route53_domain_name}"
        viewer_protocol_policy = "https-only"
        cache_policy_id  = data.aws_cloudfront_cache_policy.cacheDisable.id # here we are not caching the url so taking the data from aws like disablingcache
    }
    ordered_cache_behavior {
        path_pattern     = "/media/*"
        allowed_methods  = ["GET", "HEAD","OPTIONS"]
        cached_methods   = ["GET", "HEAD","OPTIONS"]
        target_origin_id = "dev.${var.route53_domain_name}"
        viewer_protocol_policy = "https-only"
        cache_policy_id  = data.aws_cloudfront_cache_policy.cacheEnable.id # here we are caching the url so taking the data from aws like enablingcache
    }

    restrictions {
        geo_restriction {
        restriction_type = "whitelist"
        locations        = ["US", "CA", "GB", "DE"] # in order to restrict the traffic
        }
    }

    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}"
        }
    )

    viewer_certificate {
        acm_certificate_arn = local.acm_certificate # for cdn we need to attach policy
        ssl_support_method = "sni-only"
    }
}

resource "aws_route53_record" "cloudfront_route53" {
    zone_id = var.route53_zone_id
    name = "cdn.${var.environment}.${var.route53_domain_name}" # domain name of cdn
    type = "A"
    alias {
     name = aws_cloudfront_distribution.roboshop.domain_name # storing cdn domain_name in route53
     zone_id = aws_cloudfront_distribution.roboshop.hosted_zone_id #zone_id is required for route53 in order to add the record
     evaluate_target_health = true
    }
}