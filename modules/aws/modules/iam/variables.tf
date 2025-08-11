# =============================================================================
# IAM 모듈 변수 정의
# =============================================================================

variable "prefix" {
  description = "리소스 이름 접두사 (예: myapp, dev-api)"
  type        = string
}

variable "github_owner" {
  description = "GitHub 사용자명 또는 조직명 (예: john-doe, mycompany)"
  type        = string
  default     = ""
}

variable "repository" {
  description = "GitHub 저장소 이름 (예: myapp-backend, api-service)"
  type        = string
  default     = ""
}

variable "ssm_role_name" {
  description = "EC2 SSM용 IAM Role의 이름 (예: myapp-ec2-role)"
  type        = string
}

variable "ssm_instance_profile_name" {
  description = "EC2 SSM용 Instance Profile의 이름 (예: myapp-instance-profile)"
  type        = string
}

variable "aws_role_name" {
  description = "AWS Role Name for secret"
  type        = string
}