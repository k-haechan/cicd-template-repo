# =============================================================================
# IAM (Identity and Access Management) 모듈
# =============================================================================
# 
# 이 모듈은 EC2 인스턴스가 AWS 서비스에 안전하게 접근할 수 있도록
# IAM Role, Policy, Instance Profile을 관리합니다.
# 주로 Systems Manager (SSM) 접근을 위한 권한을 제공합니다.

# =============================================================================
# EC2 인스턴스용 IAM 리소스
# =============================================================================

# EC2 인스턴스용 IAM Role
# Systems Manager 접근 및 기타 AWS 서비스 사용을 위한 권한 제공
resource "aws_iam_role" "ssm_role" {
  name = var.ssm_role_name

  # EC2 인스턴스가 이 역할을 수임할 수 있도록 하는 신뢰 정책
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = var.ssm_role_name
    Environment = "production"
    Service     = "ec2"
    ManagedBy   = "terraform"
  }
}

# Systems Manager Managed Instance Core 정책 연결
# EC2 인스턴스가 Systems Manager에 연결할 수 있는 기본 권한 제공
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# EC2 인스턴스에 연결할 Instance Profile
# EC2 인스턴스가 IAM Role을 사용할 수 있도록 하는 브리지 역할
resource "aws_iam_instance_profile" "profile" {
  name = var.ssm_instance_profile_name
  role = aws_iam_role.ssm_role.name

  tags = {
    Name        = var.ssm_instance_profile_name
    Environment = "production"
    Service     = "ec2"
    ManagedBy   = "terraform"
  }
}

# =============================================================================
# GitHub Actions OIDC (OpenID Connect) 설정
# =============================================================================
# 
# GitHub Actions에서 AWS 리소스에 안전하게 접근하기 위한 OIDC 설정입니다.
# OIDC를 사용하면 AWS 액세스 키를 GitHub에 저장하지 않고도
# GitHub Actions 워크플로우에서 AWS 서비스에 접근할 수 있습니다.

# GitHub OIDC Identity Provider
# GitHub Actions의 JWT 토큰을 검증하기 위한 OIDC 공급자
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  
  # GitHub Actions에서 발급하는 토큰의 클라이언트 ID
  client_id_list = ["sts.amazonaws.com"]
  
  # GitHub의 인증서 지문 (GitHub에서 제공하는 공식 지문)
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]

  tags = {
    Name        = "${var.prefix}-github-oidc-provider"
    Environment = "production"
    Service     = "github-actions"
    ManagedBy   = "terraform"
  }
}

# GitHub Actions용 커스텀 정책
# EC2 인스턴스에 SSM 명령을 보내고 결과를 확인할 수 있는 권한
resource "aws_iam_policy" "github_ssm_policy" {
  name = "${var.prefix}-github-ssm-policy"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:SendCommand",           # EC2 인스턴스에 명령 전송
          "ssm:GetCommandInvocation",  # 명령 실행 결과 확인
          "ec2:DescribeInstances"      # EC2 인스턴스 정보 조회
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "${var.prefix}-github-ssm-policy"
    Environment = "production"
    Service     = "github-actions"
    ManagedBy   = "terraform"
  }
}

# GitHub Actions용 IAM Role
# GitHub Actions 워크플로우에서 사용할 역할
resource "aws_iam_role" "github_actions" {
  name = var.aws_role_name
  # GitHub Actions에서 이 역할을 수임할 수 있도록 하는 신뢰 정책
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            # 특정 GitHub 저장소의 워크플로우에서만 접근 허용
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_owner}/${var.repository}:*"
          }
        }
      }
    ]
  })

  tags = {
    Name        = "${var.prefix}-github-actions-role"
    Environment = "production"
    Service     = "github-actions"
    ManagedBy   = "terraform"
  }
}

# GitHub Actions Role에 EC2 읽기 권한 연결
# EC2 인스턴스 정보를 조회할 수 있는 권한
resource "aws_iam_role_policy_attachment" "github_ec2_attach" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

# GitHub Actions Role에 커스텀 SSM 정책 연결
# EC2 인스턴스에 SSM 명령을 보낼 수 있는 권한
resource "aws_iam_role_policy_attachment" "github_ssm_attach" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_ssm_policy.arn
}
