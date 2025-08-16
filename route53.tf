resource "aws_route53_record" "aliases" {
  for_each = toset(local.aliases)
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = each.value
  records = [aws_cloudfront_distribution.this.domain_name]
  ttl     = "30"
  type    = "CNAME"
}


resource "aws_route53_record" "roote" {
  count  = var.merge_hosted_zone_name ? 1 : 0
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.hosted_zone_name
  #  records = [aws_cloudfront_distribution.this.domain_name]
  #  ttl     = "30"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false
  }
}