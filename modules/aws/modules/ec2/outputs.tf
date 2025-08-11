# =============================================================================
# EC2 모듈 출력값 정의
# =============================================================================

output "instance_id" {
  description = "생성된 EC2 인스턴스의 고유 ID"
  value       = aws_instance.main.id
}

output "public_ip" {
  description = "EC2 인스턴스의 공개 IP 주소"
  value       = aws_instance.main.public_ip
}

output "private_ip" {
  description = "EC2 인스턴스의 프라이빗 IP 주소"
  value       = aws_instance.main.private_ip
}

output "instance_arn" {
  description = "EC2 인스턴스의 ARN"
  value       = aws_instance.main.arn
}

output "instance_state" {
  description = "EC2 인스턴스의 현재 상태"
  value       = aws_instance.main.instance_state
}

output "availability_zone" {
  description = "EC2 인스턴스가 배치된 가용 영역"
  value       = aws_instance.main.availability_zone
}