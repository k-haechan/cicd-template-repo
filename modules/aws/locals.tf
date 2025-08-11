locals {
  ec2_domain        = "api.${var.project}.${var.domain_name}"
  cloudfront_domain = "static.${var.project}.${var.domain_name}"
  s3_bucket_name    = "${var.project}-cdn-bucket-${var.domain_name}"

  hosted_zone_name = "${var.project}.${var.domain_name}."
} 