# =============================================================================
# ACM 모듈 변수 정의
# =============================================================================

variable "cloudfront_domain" {
  description = "CloudFront 배포에 사용할 도메인 이름 (예: static.example.com)"
  type        = string
}

variable "ec2_domain" {
  description = "EC2 인스턴스에 사용할 도메인 이름 (예: api.example.com)"
  type        = string
}

variable "region" {
  description = "EC2 인스턴스가 배포될 AWS 리전 (예: ap-northeast-2)"
  type        = string

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+-[0-9]+$", var.region))
    error_message = "리전은 유효한 AWS 리전 형식이어야 합니다 (예: ap-northeast-2)."
  }
}

variable "zone_id" {
  description = "Route53 호스팅 존의 ID (Z1234567890ABC 형태)"
  type        = string

  validation {
    condition     = can(regex("^Z[A-Z0-9]+$", var.zone_id))
    error_message = "Zone ID는 Z로 시작하는 유효한 Route53 호스팅 존 ID여야 합니다."
  }
}