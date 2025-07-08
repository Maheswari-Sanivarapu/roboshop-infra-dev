resource "aws_acm_certificate" "pavithra" {
    domain_name = "dev.${var.route53_domain_name}"
    validation_method = "DNS"
    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-certificate"
        }
    )
    lifecycle {
    create_before_destroy = true
  }
}

# creating route53 records
resource "aws_route53_record" "pavithra" {
    for_each = {
    for dvo in aws_acm_certificate.pavithra.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53_zone_id
}

#domain validation
resource "aws_acm_certificate_validation" "pavithra" {
  certificate_arn         = aws_acm_certificate.pavithra.arn
  validation_record_fqdns = [for record in aws_route53_record.pavithra : record.fqdn]
}
