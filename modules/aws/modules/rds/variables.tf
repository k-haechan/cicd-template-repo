# =============================================================================
# RDS 모듈 변수 정의
# =============================================================================

variable "prefix" {
  description = "리소스 이름 접두사 (예: myapp, dev-api)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.prefix))
    error_message = "접두사는 소문자, 숫자, 하이픈만 사용할 수 있습니다."
  }
}

variable "private_subnet_ids" {
  description = "RDS 인스턴스를 배치할 프라이빗 서브넷 ID 목록 (최소 2개 권장)"
  type        = list(string)

  validation {
    condition = alltrue([
      for subnet_id in var.private_subnet_ids : can(regex("^subnet-[a-z0-9]+$", subnet_id))
    ])
    error_message = "모든 서브넷 ID는 'subnet-'으로 시작하는 유효한 형식이어야 합니다."
  }
}

variable "db_sg_id" {
  description = "RDS 인스턴스에 적용할 보안 그룹 ID"
  type        = string

  validation {
    condition     = can(regex("^sg-[a-z0-9]+$", var.db_sg_id))
    error_message = "보안 그룹 ID는 'sg-'로 시작하는 유효한 형식이어야 합니다."
  }
}

variable "instance_class" {
  description = "RDS 인스턴스 타입 (예: db.t3.micro, db.t3.small)"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "생성할 데이터베이스의 이름"
  type        = string
  default     = "sns"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]*$", var.db_name))
    error_message = "데이터베이스 이름은 문자로 시작하고 문자, 숫자, 언더스코어만 사용할 수 있습니다."
  }
}

variable "db_username" {
  description = "데이터베이스 마스터 사용자 이름"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]*$", var.db_username))
    error_message = "사용자 이름은 문자로 시작하고 문자, 숫자, 언더스코어만 사용할 수 있습니다."
  }
}

variable "db_password" {
  description = "데이터베이스 마스터 사용자 비밀번호 (최소 8자, 대소문자, 숫자 포함)"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "비밀번호는 최소 8자 이상이어야 합니다."
  }
}