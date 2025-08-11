# =============================================================================
# ACM 모듈 출력값 정의
# =============================================================================

output "cloudfront_cert_arn" {
  description = "CloudFront 배포에 사용할 SSL 인증서의 ARN"
  value       = aws_acm_certificate.cloudfront_cert.arn
}

output "ec2_cert_arn" {
  description = "EC2 인스턴스에 사용할 SSL 인증서의 ARN"
  value       = aws_acm_certificate.ec2_cert.arn
}

output "cloudfront_cert_status" {
  description = "CloudFront 인증서의 현재 상태"
  value       = aws_acm_certificate.cloudfront_cert.status
}

output "ec2_cert_status" {
  description = "EC2 인증서의 현재 상태"
  value       = aws_acm_certificate.ec2_cert.status
}