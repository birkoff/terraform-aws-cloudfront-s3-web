output "frontend_dist_domain_name" {
  value       = aws_cloudfront_distribution.this.domain_name
  description = "CloudFront distribution domain name of the frontend"
}

output "alias_fqdns" {
  value = {
    for key, record in aws_route53_record.aliases :
    key => record.fqdn
  }
}


output "s3_bucket_name" {
  description = "The name of the s3 bucket"
  value       = module.s3_frontend_files.s3_bucket_id
}

output "oai_iam_arn" {
  value = aws_cloudfront_origin_access_identity.this.iam_arn
}