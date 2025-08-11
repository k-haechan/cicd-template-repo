# =============================================================================
# IAM 모듈 출력값 정의
# =============================================================================

# =============================================================================
# EC2 인스턴스용 출력값
# =============================================================================

output "ssm_instance_profile_name" {
  description = "EC2 인스턴스에 할당할 IAM Instance Profile의 이름"
  value       = aws_iam_instance_profile.profile.name
}

output "ssm_role_arn" {
  description = "EC2 SSM용 IAM Role의 ARN"
  value       = aws_iam_role.ssm_role.arn
}

output "ssm_role_name" {
  description = "EC2 SSM용 IAM Role의 이름"
  value       = aws_iam_role.ssm_role.name
}

output "ssm_instance_profile_arn" {
  description = "EC2 SSM용 IAM Instance Profile의 ARN"
  value       = aws_iam_instance_profile.profile.arn
}

# =============================================================================
# GitHub Actions OIDC용 출력값
# =============================================================================

output "github_actions_role_arn" {
  description = "GitHub Actions에서 사용할 IAM Role의 ARN"
  value       = aws_iam_role.github_actions.arn
}

output "github_actions_role_name" {
  description = "GitHub Actions에서 사용할 IAM Role의 이름"
  value       = aws_iam_role.github_actions.name
}

output "github_oidc_provider_arn" {
  description = "GitHub OIDC Identity Provider의 ARN"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "github_ssm_policy_arn" {
  description = "GitHub Actions용 SSM 정책의 ARN"
  value       = aws_iam_policy.github_ssm_policy.arn
} 