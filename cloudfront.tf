locals {
  aliases = [for item in var.frontend_subdomain_aliases : "${item}.${var.hosted_zone_name}"]
}

resource "aws_cloudfront_origin_access_identity" "this" {
}

resource "aws_cloudfront_distribution" "this" {
  depends_on          = [aws_cloudfront_origin_access_identity.this, module.s3_frontend_files]
  aliases             = local.aliases
  comment             = var.comment
  default_root_object = "index.html"

  custom_error_response {
    error_caching_min_ttl = "10"
    error_code            = "403"
    response_code         = "200"
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods = ["GET", "POST", "HEAD", "DELETE", "PUT", "PATCH", "OPTIONS"]
    cached_methods  = ["HEAD", "GET"]
    compress        = "false"
    default_ttl     = "0"

    forwarded_values {
      cookies {
        forward = "none"
      }
      query_string = "true"
    }

    max_ttl                = "0"
    min_ttl                = "0"
    smooth_streaming       = "false"
    target_origin_id       = module.s3_frontend_files.s3_bucket_id
    viewer_protocol_policy = "redirect-to-https"
  }

  enabled         = "true"
  http_version    = "http2"
  is_ipv6_enabled = "true"

  origin {
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }

    connection_attempts = "3"
    connection_timeout  = "10"
    domain_name         = module.s3_frontend_files.s3_bucket_bucket_domain_name
    origin_id           = module.s3_frontend_files.s3_bucket_id
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = "false"

  viewer_certificate {
    acm_certificate_arn            = data.aws_acm_certificate.this.arn
    cloudfront_default_certificate = "false"
    minimum_protocol_version       = "TLSv1.2_2018"
    ssl_support_method             = "sni-only"
  }

  logging_config {
    include_cookies = false
    bucket          = "${var.logs_bucket}.s3.amazonaws.com"
    prefix          = var.logs_prefix
  }
}