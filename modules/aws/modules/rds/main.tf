# =============================================================================
# RDS (Relational Database Service) 모듈
# =============================================================================
# 
# 이 모듈은 MySQL 데이터베이스 인스턴스를 관리합니다.
# 프라이빗 서브넷에 배치되며, 보안 그룹을 통해 접근을 제어합니다.

# =============================================================================
# RDS 서브넷 그룹
# =============================================================================

# RDS 인스턴스를 배치할 서브넷 그룹
# 프라이빗 서브넷에 배치하여 보안 강화
resource "aws_db_subnet_group" "this" {
  name       = "${var.prefix}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.prefix}-db-subnet-group"
    Environment = "production"
    Service     = "rds"
    ManagedBy   = "terraform"
  }
}

# =============================================================================
# RDS 인스턴스
# =============================================================================

# MySQL 데이터베이스 인스턴스
resource "aws_db_instance" "this" {
  # 기본 식별 정보
  identifier = "${var.prefix}-db"
  
  # 엔진 설정
  engine         = "mysql"
  engine_version = "8.0"
  
  # 인스턴스 설정
  instance_class = var.instance_class
  
  # 데이터베이스 설정
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  
  # 스토리지 설정
  allocated_storage = 20
  storage_type      = "gp2"
  
  # 네트워크 설정
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_sg_id]
  publicly_accessible    = false
  
  # 고가용성 설정
  multi_az = false
  
  # 백업 및 스냅샷 설정
  skip_final_snapshot = true
  
  # 성능 인사이트 설정
  performance_insights_enabled = false
  
  # 모니터링 설정
  monitoring_interval = 0
  
  # 유지 관리 설정
  auto_minor_version_upgrade = true
  
  # 암호화 설정
  storage_encrypted = true
  
  # 삭제 보호 설정
  deletion_protection = false
  
  # 리소스 태그
  tags = {
    Name        = "${var.prefix}-rds"
    Environment = "production"
    Service     = "rds"
    ManagedBy   = "terraform"
  }
}