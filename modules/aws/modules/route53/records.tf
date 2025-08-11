# =============================================================================
# Route53 DNS 레코드 설정
# =============================================================================
# 
# 이 파일은 Route53 호스팅 존에 DNS 레코드를 생성합니다.
# API 서버와 CDN에 대한 A 레코드와 별칭 레코드를 관리합니다.

# =============================================================================
# API 서버 DNS 레코드
# =============================================================================

# API 서버용 A 레코드
# EC2 인스턴스의 공개 IP 주소를 가리키는 레코드
resource "aws_route53_record" "api" {
  zone_id = var.zone_id
  name    = var.api_domain
  type    = "A"
  ttl     = 300  # 5분 TTL
  
  # API 서버의 IP 주소 (EC2 인스턴스의 공개 IP)
  records = [var.api_target]
}

# =============================================================================
# CDN DNS 레코드
# =============================================================================

# CDN용 별칭 레코드
# CloudFront 배포를 가리키는 별칭 레코드
resource "aws_route53_record" "cdn" {
  zone_id = var.zone_id
  name    = var.cdn_domain
  type    = "A"
  
  # CloudFront 배포를 가리키는 별칭 설정
  alias {
    name                   = var.cdn_target
    zone_id                = var.cdn_target_zone_id
    evaluate_target_health = false
  }
} 