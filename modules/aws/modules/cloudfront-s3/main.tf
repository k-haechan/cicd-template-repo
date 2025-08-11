# =============================================================================
# CloudFront 배포 설정
# =============================================================================
# 
# 이 파일은 CloudFront CDN 배포를 위한 주요 설정을 포함합니다.
# S3 버킷을 오리진으로 사용하며, 사용자 정의 도메인과 SSL 인증서를 지원합니다.

# CloudFront 배포 리소스
resource "aws_cloudfront_distribution" "cdn" {
  # 오리진 설정 (S3 버킷)
  origin {
    domain_name              = aws_s3_bucket.cdn.bucket_regional_domain_name
    origin_id                = "s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  # 배포 활성화
  enabled = true

  # 사용자 정의 도메인 별칭 설정
  aliases = [var.cloudfront_domain]

  # 기본 캐시 동작 설정 (정적 파일용)
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-origin"

    # HTTPS 리다이렉트 설정
    viewer_protocol_policy = "redirect-to-https"

    # 캐시 설정
    min_ttl     = 0
    default_ttl = 3600    # 1시간
    max_ttl     = 86400   # 24시간

    # 쿼리 문자열 및 쿠키 전달 설정
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  # 서명된 쿠키를 사용하는 프라이빗 콘텐츠용 캐시 동작
  ordered_cache_behavior {
    path_pattern     = "/private/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-origin"

    # HTTPS 리다이렉트 설정
    viewer_protocol_policy = "redirect-to-https"

    # 서명된 쿠키 키 그룹 설정
    trusted_key_groups = [aws_cloudfront_key_group.signed_cookie_key_group.id]

    # 캐시 설정
    min_ttl     = 0
    default_ttl = 3600    # 1시간
    max_ttl     = 86400   # 24시간

    # 쿼리 문자열, 쿠키, 헤더 전달 설정
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
      headers = [
        "Origin",
        "Access-Control-Request-Headers",
        "Access-Control-Request-Method"
      ]
    }
  }

  # SSL 인증서 설정
  viewer_certificate {
    acm_certificate_arn      = var.cloudfront_cert_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # 지리적 제한 설정 (현재는 제한 없음)
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # 리소스 태그
  tags = {
    Name        = "${var.prefix}-cdn"
    Environment = "production"
    Service     = "cloudfront"
  }
}