# =============================================================================
# VPC 모듈 출력값 정의
# =============================================================================

output "vpc_id" {
  description = "생성된 VPC의 고유 ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "VPC의 CIDR 블록"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "퍼블릭 서브넷 ID 목록 (EC2 인스턴스 배치용)"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "private_subnet_ids" {
  description = "프라이빗 서브넷 ID 목록 (RDS 데이터베이스 배치용)"
  value       = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

output "igw_id" {
  description = "인터넷 게이트웨이의 ID"
  value       = aws_internet_gateway.igw.id
}

output "public_route_table_id" {
  description = "퍼블릭 라우팅 테이블의 ID"
  value       = aws_route_table.public_rt.id
}

output "backend_security_group_id" {
  description = "백엔드 애플리케이션용 보안 그룹 ID (EC2 인스턴스에 적용)"
  value       = aws_security_group.backend.id
}

output "database_security_group_id" {
  description = "데이터베이스용 보안 그룹 ID (RDS 인스턴스에 적용)"
  value       = aws_security_group.database.id
}