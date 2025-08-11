module "aws" {
  source  = "./modules/aws"
  project = var.project
  domain_name = var.domain_name
  region  = var.region
  ec2_ami = var.ec2_ami
  ec2_instance_type = var.ec2_instance_type
  rds_instance_class = var.rds_instance_class
  db_name = local.db_name
  db_username = var.db_username
  db_password = var.db_password
  public_key = var.public_key
  github_owner = var.github_owner
  email = var.email
  repository = local.repository
  aws_role_name = local.aws_role_name
}

module "github" {
  source         = "./modules/github"
  project        = var.project
  github_owner   = var.github_owner
  github_token   = var.github_token
  aws_account_id = module.aws.aws_account_id
  repository = local.repository
  region = var.region
  aws_role_name = local.aws_role_name
}