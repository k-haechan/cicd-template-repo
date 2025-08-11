# =============================================================================
# CloudFront-S3 모듈 출력값 정의
# =============================================================================

output "cloudfront_distribution_id" {
  description = "CloudFront 배포의 고유 ID"
  value       = aws_cloudfront_distribution.cdn.id
}

output "cloudfront_domain_name" {
  description = "CloudFront 배포의 기본 도메인 이름 (예: d1234567890abc.cloudfront.net)"
  value       = aws_cloudfront_distribution.cdn.domain_name
}

output "cloudfront_distribution_arn" {
  description = "CloudFront 배포의 ARN"
  value       = aws_cloudfront_distribution.cdn.arn
}

output "s3_bucket_name" {
  description = "CDN용 S3 버킷의 이름"
  value       = aws_s3_bucket.cdn.bucket
}

output "s3_bucket_arn" {
  description = "CDN용 S3 버킷의 ARN"
  value       = aws_s3_bucket.cdn.arn
}

output "s3_bucket_region" {
  description = "CDN용 S3 버킷이 위치한 리전"
  value       = aws_s3_bucket.cdn.region
}