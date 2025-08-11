# =============================================================================
# 보안 그룹 설정
# =============================================================================
# 
# 이 파일은 VPC 내의 리소스에 대한 네트워크 보안을 관리합니다.
# 백엔드 애플리케이션과 데이터베이스에 대한 접근 제어를 설정합니다.

# =============================================================================
# 백엔드 애플리케이션 보안 그룹
# =============================================================================

# 백엔드 애플리케이션용 보안 그룹
# EC2 인스턴스에 적용되어 웹 트래픽을 허용
resource "aws_security_group" "backend" {
  name        = "${var.prefix}-backend-sg"
  description = "Backend application security group for EC2 instances"
  vpc_id      = aws_vpc.main.id

  # HTTP 트래픽 허용 (포트 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access from anywhere"
  }

  # HTTPS 트래픽 허용 (포트 443)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access from anywhere"
  }

  # SSH 접근 허용 (포트 22) - 개발/관리용
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access from anywhere"
  }

  # 모든 아웃바운드 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.prefix}-backend-sg"
    Environment = "production"
    Service     = "vpc"
    Type        = "backend"
    ManagedBy   = "terraform"
  }
}

# =============================================================================
# 데이터베이스 보안 그룹
# =============================================================================

# 데이터베이스용 보안 그룹
# RDS 인스턴스에 적용되어 백엔드에서만 접근 허용
resource "aws_security_group" "database" {
  name        = "${var.prefix}-db-sg"
  description = "Database security group for RDS instances"
  vpc_id      = aws_vpc.main.id

  # MySQL 포트 (3306) - 백엔드 보안 그룹에서만 접근 허용
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.backend.id]
    description     = "MySQL access from backend security group"
  }

  # 모든 아웃바운드 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.prefix}-db-sg"
    Environment = "production"
    Service     = "vpc"
    Type        = "database"
    ManagedBy   = "terraform"
  }
} 