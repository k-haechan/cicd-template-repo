# =============================================================================
# EC2 모듈 변수 정의
# =============================================================================

variable "prefix" {
  description = "리소스 이름 접두사 (예: myapp, dev-api)"
  type        = string
}

variable "ami" {
  description = "EC2 인스턴스에 사용할 AMI ID (예: ami-12345678)"
  type        = string
}

variable "instance_type" {
  description = "EC2 인스턴스 타입 (예: t3.micro, t3.small)"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "EC2 인스턴스를 배치할 서브넷 ID (예: subnet-12345678)"
  type        = string
}

variable "security_group_ids" {
  description = "EC2 인스턴스에 적용할 보안 그룹 ID 목록"
  type        = list(string)
}

variable "instance_profile_name" {
  description = "EC2 인스턴스에 할당할 IAM Instance Profile 이름"
  type        = string
}

variable "api_domain" {
  description = "API 도메인"
  type        = string
}

variable "email" {
  description = "인증서 발급 시 필요한 이메일을 입력해주세요. "
  type        = string
}