variable "hosted_zone_name" {}

variable "bucket_region" {
  description = "Region of the S3 bucket"
}

variable "bucket_force_destroy" {
  default = "false"
}

variable "cloudfront_function_publish" {
  default = true
}

variable "comment" {
  type    = string
  default = ""
}

variable "create_logs_bucket" {
  type    = bool
  default = true
}

variable "frontend_subdomain_aliases" {
  type    = list(string)
  default = []
}

variable "logs_bucket" {
  type    = string
  default = ""
}

variable "logs_prefix" {
  type    = string
  default = ""
}

variable "merge_hosted_zone_name" {
  default = false
}