# =============================================================================
# EC2 인스턴스 설정
# =============================================================================
# 
# 이 파일은 EC2 인스턴스 생성 및 초기 설정을 관리합니다.
# Docker 설치, 스왑 메모리 설정, 네트워크 구성 등을 포함합니다.

# =============================================================================
# Local Values
# =============================================================================

locals {
  user_data = <<-EOF
    #!/bin/bash

    # 시스템 업데이트
    apt-get update -y

    # 4GB 스왑 메모리 생성 및 설정
    fallocate -l 4G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
    sysctl vm.swappiness=10
    echo 'vm.swappiness=10' >> /etc/sysctl.conf

    # Docker 설치
    apt-get install -y docker.io
    systemctl enable docker
    systemctl start docker

    # Docker 네트워크 생성
    docker network create common

    # Certbot, HAProxy 설치
    apt-get install -y certbot haproxy

    DOMAIN="${var.api_domain}"
    EMAIL="${var.email}"

    # 인증서 발급
    certbot certonly --standalone -d "$DOMAIN" -m "$EMAIL" --agree-tos --non-interactive

    # 인증서 병합
    mkdir -p /etc/haproxy/certs
    cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem /etc/letsencrypt/live/$DOMAIN/privkey.pem \
      > /etc/haproxy/certs/$DOMAIN.pem
    chown root:haproxy /etc/haproxy/certs/$DOMAIN.pem
    chmod 640 /etc/haproxy/certs/$DOMAIN.pem

    # HAProxy 설정
    cat > /etc/haproxy/haproxy.cfg <<EOCFG
    global
        log /dev/log local0
        log /dev/log local1 notice
        chroot /var/lib/haproxy
        user haproxy
        group haproxy
        daemon
        maxconn 2000
        tune.ssl.default-dh-param 2048
        ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256
        ssl-default-bind-options no-sslv3 no-tlsv10 no-tlsv11
        ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384

    defaults
        log     global
        mode    http
        option  httplog
        option  dontlognull
        timeout connect 5s
        timeout client  50s
        timeout server  50s

    frontend http_in
        bind *:80
        mode http
        redirect scheme https code 301

    frontend https_in
        bind *:443 ssl crt /etc/haproxy/certs/
        acl host_api hdr(host) -i $DOMAIN
        use_backend backend_api if host_api

    backend backend_api
        balance roundrobin
        option httpchk GET /actuator/health
        default-server inter 2s rise 1 fall 1
        option redispatch
        server api_server_1 127.0.0.1:8080 check
        server api_server_2 127.0.0.1:8081 check
    EOCFG

    # HAProxy 설정 적용
    haproxy -c -f /etc/haproxy/haproxy.cfg && systemctl restart haproxy

    # Certbot 갱신 훅 등록
    mkdir -p /etc/letsencrypt/renewal-hooks/deploy

    cat > /etc/letsencrypt/renewal-hooks/deploy/haproxy-reload.sh <<EOSH
    #!/bin/bash
    cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem /etc/letsencrypt/live/$DOMAIN/privkey.pem > /etc/haproxy/certs/$DOMAIN.pem
    chown root:haproxy /etc/haproxy/certs/$DOMAIN.pem
    chmod 640 /etc/haproxy/certs/$DOMAIN.pem
    systemctl reload haproxy
    EOSH

    chmod +x /etc/letsencrypt/renewal-hooks/deploy/haproxy-reload.sh

    # Certbot 타이머 활성화
    systemctl enable --now certbot.timer
  EOF
}

# =============================================================================
# EC2 인스턴스 리소스
# =============================================================================

# 메인 EC2 인스턴스
resource "aws_instance" "main" {
  # 기본 설정
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  
  # 네트워크 설정
  associate_public_ip_address = true
  vpc_security_group_ids      = var.security_group_ids
  
  # IAM 설정
  iam_instance_profile = var.instance_profile_name
  
  # 초기화 스크립트
  user_data = templatefile("${path.module}/user_data.sh", {
    domain = var.api_domain
    email  = var.email
  })
  
  # 루트 볼륨 설정
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    
    tags = {
      Name        = "${var.prefix}-ec2-root-volume"
      Environment = "production"
      Service     = "ec2"
    }
  }
  
  # 리소스 태그
  tags = {
    Name        = "${var.prefix}-ec2"
    Environment = "production"
    Service     = "ec2"
    ManagedBy   = "terraform"
    Role        = "app-server"
  }
}
