variable "project" {
  type    = string
  description = "The name of the project"
}

variable "github_owner" {
  type        = string
  description = "The owner of the GitHub repository"
}

variable "github_token" {
  type        = string
  description = "The token of the GitHub repository"
}

variable "email" {
  type        = string
  description = "The email of the project"
}

variable "domain_name" {
  type        = string
  description = "The domain name of the project"
}

variable "region" {
  type        = string
  description = "The region of the project"
  default = "ap-northeast-2"
}

variable "ec2_ami" {
  type        = string
  description = "The AMI of the project(Ubuntu 22.04)"
  default = "ami-0c9c942bd7bf113a2"
}

variable "ec2_instance_type" {
  type        = string
  description = "The instance type of the project"
  default = "t3.micro"
}

variable "rds_instance_class" {
  type        = string
  description = "The instance class of the project"
  default = "db.t3.micro"
}

variable "db_username" {
  type        = string
  description = "The username of the database"
}

variable "db_password" {
  type        = string
  description = "The password of the database"
}

variable "public_key" {
  type        = string
  description = "The public key of the project"
}
