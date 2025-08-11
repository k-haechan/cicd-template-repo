# =============================================================================
# VPC 모듈 변수 정의
# =============================================================================

variable "prefix" {
  description = "리소스 이름 접두사 (예: myapp, dev-api)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.prefix))
    error_message = "접두사는 소문자, 숫자, 하이픈만 사용할 수 있습니다."
  }
}

variable "region" {
  description = "AWS 리전 (예: ap-northeast-2, us-east-1)"
  type        = string

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+-[0-9]+$", var.region))
    error_message = "리전은 유효한 AWS 리전 형식이어야 합니다 (예: ap-northeast-2)."
  }
}