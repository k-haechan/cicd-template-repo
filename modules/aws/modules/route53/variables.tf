# =============================================================================
# Route53 모듈 변수 정의
# =============================================================================

variable "domain_name" {
  description = "메인 도메인 이름 (예: example.com)"
  type        = string
}

variable "api_domain" {
  description = "API 서버용 서브도메인 (예: api.example.com)"
  type        = string
  default     = ""
}

variable "api_target" {
  description = "API 서버의 타겟 IP 주소 (EC2 인스턴스의 공개 IP)"
  type        = string
  default     = ""
}

variable "api_target_zone_id" {
  description = "API 서버 타겟의 Zone ID (현재 사용되지 않음)"
  type        = string
  default     = ""
}

variable "cdn_domain" {
  description = "CDN용 서브도메인 (예: static.example.com)"
  type        = string
  default     = ""
}

variable "cdn_target" {
  description = "CDN 타겟 도메인 (CloudFront 배포의 도메인 이름)"
  type        = string
  default     = ""
}

variable "cdn_target_zone_id" {
  description = "CDN 타겟의 Zone ID (CloudFront의 경우 Z2FDTNDATAQYW2)"
  type        = string
  default     = ""
}

variable "zone_id" {
  description = "Route53 호스팅 존의 ID (Z1234567890ABC 형태)"
  type        = string
}