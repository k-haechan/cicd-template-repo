#!/bin/bash

set -e

# 변수 입력 받기
read -p "프로젝트 이름(project): " project
read -p "GitHub 소유자(github_owner): " github_owner
read -p "GitHub 토큰(github_token): " github_token
read -p "이메일(email): " email
read -p "도메인(domain_name): " domain_name
read -p "DB 사용자명(db_username): " db_username
read -p "DB 비밀번호(db_password): " db_password

# openssl로 PEM 키 쌍 생성
KEY_DIR="keygroup"
KEY_NAME="id_rsa"
mkdir -p "$KEY_DIR"
if [ ! -f "$KEY_DIR/${KEY_NAME}.pem" ]; then
  openssl genrsa -out "$KEY_DIR/${KEY_NAME}.pem" 2048
  openssl rsa -pubout -in "$KEY_DIR/${KEY_NAME}.pem" -out "$KEY_DIR/${KEY_NAME}_public.pem"
fi

# public_key 읽기 (PEM 전체)
public_key=$(cat "$KEY_DIR/${KEY_NAME}_public.pem")


# tfvars 파일 생성 (public_key는 PEM 전체를 <<EOF ... EOF 블록으로)
cat > terraform.tfvars <<EOF
project        = "$project"
github_owner   = "$github_owner"
github_token   = "$github_token"
email          = "$email"
domain_name    = "$domain_name"
db_username    = "$db_username"
db_password    = "$db_password"
public_key     = <<EOKEY
$public_key
EOKEY
EOF

echo "키와 tfvars 파일이 생성되었습니다."
echo " - 공개키: $KEY_DIR/${KEY_NAME}_public.pem"
echo " - 개인키: $KEY_DIR/${KEY_NAME}.pem"
echo " - tfvars: terraform.tfvars" 