// 예시: VPC만 생성하는 구조 (실제 리소스는 필요에 따라 추가)
module "vpc" {
  source = "./modules/vpc"
  prefix = var.project
  region = var.region
}

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

module "iam" {
  source = "./modules/iam"
  prefix                    = var.project
  ssm_role_name             = "${var.project}-ec2-role"
  ssm_instance_profile_name = "${var.project}-instance-profile"
  github_owner              = var.github_owner
  repository                = var.repository
  aws_role_name             = var.aws_role_name
}

module "ec2" {
  source = "./modules/ec2"
  prefix                = var.project
  ami                   = var.ec2_ami
  instance_type         = var.ec2_instance_type
  subnet_id             = module.vpc.public_subnet_ids[0]
  security_group_ids    = [module.vpc.backend_security_group_id]
  instance_profile_name = module.iam.ssm_instance_profile_name
  api_domain            = local.ec2_domain
  email                 = var.email
}

module "rds" {
  source = "./modules/rds"
  prefix             = var.project
  instance_class     = var.rds_instance_class
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  private_subnet_ids = module.vpc.private_subnet_ids
  db_sg_id           = module.vpc.database_security_group_id
}

data "aws_route53_zone" "main" {
  name         = local.hosted_zone_name
  private_zone = false
}

module "acm" {
  source = "./modules/acm"
  region = var.region
  cloudfront_domain = local.cloudfront_domain
  ec2_domain        = local.ec2_domain
  zone_id           = data.aws_route53_zone.main.zone_id
  providers = {
    aws.us_east_1  = aws.us_east_1
    aws.ec2_region = aws
  }
}

module "cloudfront_s3" {
  source = "./modules/cloudfront-s3"
  prefix              = var.project
  cloudfront_domain   = local.cloudfront_domain
  cloudfront_cert_arn = module.acm.cloudfront_cert_arn
  bucket_name         = local.s3_bucket_name
  public_key          = var.public_key
}

module "route53_records" {
  source = "./modules/route53"
  zone_id = data.aws_route53_zone.main.zone_id
  domain_name         = var.domain_name
  api_domain          = local.ec2_domain
  api_target          = module.ec2.public_ip
  cdn_domain          = local.cloudfront_domain
  cdn_target          = module.cloudfront_s3.cloudfront_domain_name
  cdn_target_zone_id  = "Z2FDTNDATAQYW2"
} 

data "aws_caller_identity" "current" {}

