data "aws_route53_zone" "root" {
  name = "${var.root_hosted_zone}."
}

resource "aws_acm_certificate" "this" {
  provider = aws.dns

  domain_name       = "${var.subdomain_path}.${var.root_hosted_zone}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.root.zone_id
}

resource "aws_acm_certificate_validation" "this" {
  provider = aws.dns

  certificate_arn = aws_acm_certificate.this.arn
}

resource "aws_api_gateway_domain_name" "this" {
  certificate_arn = aws_acm_certificate_validation.this.certificate_arn
  domain_name     = "${var.subdomain_path}.${var.root_hosted_zone}"

  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_base_path_mapping" "this" {
  domain_name = aws_api_gateway_domain_name.this.domain_name
  api_id      = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this[0].stage_name
}

resource "aws_route53_record" "this" {
  name    = aws_api_gateway_domain_name.this.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.root.id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.this.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.this.cloudfront_zone_id
  }
}
