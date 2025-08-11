# =============================================================================
# CloudFront-S3 모듈 변수 정의
# =============================================================================

variable "prefix" {
  description = "리소스 이름 접두사 (예: myapp, dev-api)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.prefix))
    error_message = "접두사는 소문자, 숫자, 하이픈만 사용할 수 있습니다."
  }
}

variable "cloudfront_domain" {
  description = "CloudFront 배포에 사용할 도메인 이름 (예: static.example.com)"
  type        = string
}

variable "cloudfront_cert_arn" {
  description = "CloudFront 배포에 사용할 ACM 인증서의 ARN"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:acm:us-east-1:[0-9]{12}:certificate/[a-zA-Z0-9-]+$", var.cloudfront_cert_arn))
    error_message = "CloudFront 인증서 ARN은 유효한 ACM 인증서 ARN 형식이어야 합니다."
  }
}

variable "bucket_name" {
  description = "CDN용 S3 버킷 이름 (전역적으로 고유해야 함)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket_name))
    error_message = "S3 버킷 이름은 소문자, 숫자, 하이픈, 점만 사용할 수 있으며, 3-63자 길이여야 합니다."
  }
}

variable "public_key" {
  description = "서명된 쿠키 인증을 위한 공개키 (PEM 형식)"
  type        = string
  default     = ""

  validation {
    condition     = var.public_key == "" || can(regex("^-----BEGIN PUBLIC KEY-----", var.public_key))
    error_message = "공개키는 PEM 형식이어야 합니다."
  }
}