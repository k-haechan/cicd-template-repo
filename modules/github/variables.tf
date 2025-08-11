variable "project" {
  description = "Project name"
  type        = string
}

variable "github_owner" {
  description = "GitHub owner (username or organization)"
  type        = string
}

variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
}

variable "repository" {
  description = "GitHub repository name"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID for secret"
  type        = string
}

variable "aws_role_name" {
  description = "AWS Role Name for secret"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string  
}

variable "init_files" {
  description = "init 브랜치에 커밋할 모든 파일 경로 리스트"
  type        = list(string)
  default     = [
    "Dockerfile",
    ".gemini/styleguide.md",
    ".github/PULL_REQUEST_TEMPLATE.md",
    ".github/ruleset/dev-branch-ruleset.json",
    ".github/ruleset/main-branch-ruleset.json",
    ".github/ISSUE_TEMPLATE/refactor_task.md",
    ".github/ISSUE_TEMPLATE/feature_task.md",
    ".github/ISSUE_TEMPLATE/chore_task.md",
    ".github/ISSUE_TEMPLATE/bugfix_task.md",
    ".github/workflows/ci.yml",
    ".github/workflows/cd.yml"
  ]
}