# =============================================================================
# RDS 모듈 출력값 정의
# =============================================================================

output "endpoint" {
  description = "RDS 인스턴스의 연결 엔드포인트 (호스트:포트)"
  value       = aws_db_instance.this.endpoint
}

output "db_instance_id" {
  description = "RDS 인스턴스의 고유 ID"
  value       = aws_db_instance.this.id
}

output "db_name" {
  description = "생성된 데이터베이스의 이름"
  value       = aws_db_instance.this.db_name
}

output "db_instance_arn" {
  description = "RDS 인스턴스의 ARN"
  value       = aws_db_instance.this.arn
}

output "db_instance_status" {
  description = "RDS 인스턴스의 현재 상태"
  value       = aws_db_instance.this.status
}

output "db_subnet_group_name" {
  description = "RDS 서브넷 그룹의 이름"
  value       = aws_db_subnet_group.this.name
}