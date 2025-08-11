# =============================================================================
# CloudFront Origin Access Control 및 서명된 쿠키 설정
# =============================================================================
# 
# 이 파일은 S3 버킷에 대한 안전한 접근을 위한 Origin Access Control과
# 프라이빗 콘텐츠 접근을 위한 서명된 쿠키 키 그룹을 설정합니다.

# CloudFront Origin Access Control (OAC)
# S3 버킷에 대한 안전한 접근을 위한 설정
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${var.prefix}-oac"
  description                       = "Origin Access Control for S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront 공개키 (서명된 쿠키용)
# 프라이빗 콘텐츠 접근을 위한 서명된 쿠키 생성에 사용
resource "aws_cloudfront_public_key" "signed_cookie_key" {
  comment     = "Public key for signed cookies authentication"
  encoded_key = var.public_key
  name        = "${var.prefix}-signed-cookie-key"
}

# CloudFront 키 그룹
# 서명된 쿠키를 사용하는 캐시 동작에서 참조하는 키 그룹
resource "aws_cloudfront_key_group" "signed_cookie_key_group" {
  comment = "Key group for signed cookies authentication"
  items   = [aws_cloudfront_public_key.signed_cookie_key.id]
  name    = "${var.prefix}-signed-cookie-key-group"
} 