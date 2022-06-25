# data "aws_route53_zone" "labs_domain" {
#   name = var.domain_name
# }

# resource "aws_route53_record" "sentiment_domain_validation" {
#   count = aws_acm_certificate.sentiment_labs_certificate.status == "PENDING_VALIDATION" ? 1 : 0

#   zone_id = data.aws_route53_zone.labs_domain.zone_id
#   name    = element(aws_acm_certificate.sentiment_labs_certificate.domain_validation_options[*].resource_record_name, 1)
#   type    = "CNAME"
#   ttl     = "5"

#   weighted_routing_policy {
#     weight = 10
#   }

#   set_identifier = "dev"
#   records        = [element(aws_acm_certificate.sentiment_labs_certificate.domain_validation_options[*].resource_record_value, 1)]
# }

# resource "aws_route53_record" "sentiment_domain" {
#   count = aws_acm_certificate.sentiment_labs_certificate.status == "ISSUED" ? 1 : 0

#   zone_id = data.aws_route53_zone.labs_domain.zone_id
#   name    = "sentiment.${var.domain_name}"
#   type    = "A"

#   # weighted_routing_policy {
#   #   weight = 10
#   # }

#   alias {
#     name                   = aws_cloudfront_distribution.cdn[0].domain_name
#     zone_id                = aws_cloudfront_distribution.cdn[0].hosted_zone_id
#     evaluate_target_health = false
#   }
# }

# COGNITO
# resource "aws_route53_record" "auth_cognito_A" {
#   name    = aws_cognito_user_pool_domain.main[0].domain
#   type    = "A"
#   zone_id = data.aws_route53_zone.labs_domain.zone_id
#   alias {
#     evaluate_target_health = false
#     name                   = aws_cognito_user_pool_domain.main[0].cloudfront_distribution_arn
#     # This zone_id is fixed
#     zone_id = "Z2FDTNDATAQYW2"
#   }
# }