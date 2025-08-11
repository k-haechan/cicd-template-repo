# =============================================================================
# ACM (AWS Certificate Manager) 모듈
# =============================================================================
# 
# 이 모듈은 CloudFront와 EC2 인스턴스를 위한 SSL/TLS 인증서를 관리합니다.
# CloudFront는 us-east-1 리전에서, EC2는 지정된 리전에서 인증서를 생성합니다.
#
# Provider 설정 예시:
# module "acm" {
#   source = "./modules/acm"
#   providers = {
#     aws.us_east_1  = aws.us_east_1
#     aws.ec2_region = aws.ap_northeast_2
#   }
# }

# =============================================================================
# Terraform 설정
# =============================================================================

terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 5.0"
      configuration_aliases = [aws.us_east_1, aws.ec2_region]
    }
  }
}

# =============================================================================
# Data Sources
# =============================================================================

# Route 53 호스팅 존 조회 (zone_id로)
data "aws_route53_zone" "main" {
  zone_id = var.zone_id
}

# =============================================================================
# ACM 인증서 리소스
# =============================================================================

# CloudFront용 SSL 인증서 (us-east-1 리전 필수)
resource "aws_acm_certificate" "cloudfront_cert" {
  provider          = aws.us_east_1
  domain_name       = var.cloudfront_domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "${var.cloudfront_domain}-cloudfront-cert"
    Environment = "production"
    Service     = "cloudfront"
  }
}

# EC2 인스턴스용 SSL 인증서 (지정된 리전)
resource "aws_acm_certificate" "ec2_cert" {
  provider          = aws.ec2_region
  domain_name       = var.ec2_domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "${var.ec2_domain}-ec2-cert"
    Environment = "production"
    Service     = "ec2"
  }
}

# =============================================================================
# Local Values
# =============================================================================

locals {
  # 도메인 검증 옵션 추출
  cloudfront_domain_validation = tolist(aws_acm_certificate.cloudfront_cert.domain_validation_options)[0]
  ec2_domain_validation        = tolist(aws_acm_certificate.ec2_cert.domain_validation_options)[0]
}

# =============================================================================
# DNS 검증 레코드
# =============================================================================

# CloudFront 인증서 DNS 검증 레코드
resource "aws_route53_record" "cloudfront_cert_validation" {
  provider = aws.us_east_1
  zone_id  = data.aws_route53_zone.main.zone_id
  name     = local.cloudfront_domain_validation.resource_record_name
  type     = local.cloudfront_domain_validation.resource_record_type
  ttl      = 60
  records  = [local.cloudfront_domain_validation.resource_record_value]
}

# EC2 인증서 DNS 검증 레코드
resource "aws_route53_record" "ec2_cert_validation" {
  provider = aws.ec2_region
  zone_id  = data.aws_route53_zone.main.zone_id
  name     = local.ec2_domain_validation.resource_record_name
  type     = local.ec2_domain_validation.resource_record_type
  ttl      = 60
  records  = [local.ec2_domain_validation.resource_record_value]
}

# =============================================================================
# 인증서 검증 완료 리소스
# =============================================================================

# CloudFront 인증서 검증 완료
resource "aws_acm_certificate_validation" "cloudfront_cert_validation" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.cloudfront_cert.arn
  validation_record_fqdns = [aws_route53_record.cloudfront_cert_validation.fqdn]

  timeouts {
    create = "5m"
  }
}

# EC2 인증서 검증 완료
resource "aws_acm_certificate_validation" "ec2_cert_validation" {
  provider                = aws.ec2_region
  certificate_arn         = aws_acm_certificate.ec2_cert.arn
  validation_record_fqdns = [aws_route53_record.ec2_cert_validation.fqdn]

  timeouts {
    create = "5m"
  }
}