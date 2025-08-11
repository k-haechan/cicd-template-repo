# =============================================================================
# S3 버킷 설정
# =============================================================================
# 
# 이 파일은 CloudFront CDN의 오리진으로 사용할 S3 버킷을 설정합니다.
# 버킷은 프라이빗으로 설정되며, CloudFront Origin Access Control을 통해 접근됩니다.

# S3 버킷 리소스
resource "aws_s3_bucket" "cdn" {
  bucket = var.bucket_name

  tags = {
    Name        = "${var.prefix}-cdn-bucket"
    Environment = "production"
    Service     = "cloudfront"
  }
}

# S3 버킷 공개 액세스 차단 설정
resource "aws_s3_bucket_public_access_block" "cdn" {
  bucket = aws_s3_bucket.cdn.id

  # 모든 공개 액세스 차단
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 버킷 정책 (CloudFront만 접근 허용)
resource "aws_s3_bucket_policy" "cdn" {
  bucket = aws_s3_bucket.cdn.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.cdn.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cdn.arn
          }
        }
      }
    ]
  })
} 