resource "aws_route53_record" "aliases" {
  for_each = toset(local.aliases)
  zone_id  = data.aws_route53_zone.selected.zone_id
  name     = each.value
  records  = [aws_cloudfront_distribution.this.domain_name]
  ttl      = "30"
  type     = "CNAME"
}
