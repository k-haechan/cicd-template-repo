provider "github" {
  token = var.github_token
  owner = var.github_owner
}

resource "github_repository" "repo" {
  name        = var.repository
  description = "Backend repository for ${var.project}"
  visibility  = "public"
  auto_init   = true
  has_issues  = true
}

resource "github_branch_default" "default" {
  repository = github_repository.repo.name
  branch     = "main"
}

resource "github_actions_secret" "aws_account_id" {
  repository      = github_repository.repo.name
  secret_name     = "AWS_ACCOUNT_ID"
  plaintext_value = var.aws_account_id
}

resource "github_actions_variable" "project_name" {
  repository    = github_repository.repo.name
  variable_name = "PROJECT_NAME"
  value         = var.project
} 

resource "github_actions_variable" "aws_role_name" {
  repository    = github_repository.repo.name
  variable_name = "AWS_ROLE_NAME"
  value         = var.aws_role_name
}

resource "github_actions_variable" "aws_region" {
  repository    = github_repository.repo.name
  variable_name = "AWS_REGION"
  value         = var.aws_role_name
}

resource "github_branch" "dev" {
  repository    = github_repository.repo.name
  branch        = "dev"
  source_branch = "main"
}

resource "github_branch" "init" {
  repository    = github_repository.repo.name
  branch        = "init"
  source_branch = "main"
}

resource "github_repository_file" "init_files" {
  for_each            = toset(var.init_files)
  repository          = github_repository.repo.name
  file                = each.value
  content             = file("${path.module}/init/${each.value}")
  branch              = github_branch.init.branch
  commit_message      = "init"
  overwrite_on_create = true
}

resource "github_issue_label" "major" {
  repository  = github_repository.repo.name
  name        = "major"
  color       = "b60205"
  description = "Major version update"
}

resource "github_issue_label" "minor" {
  repository  = github_repository.repo.name
  name        = "minor"
  color       = "0e8a16"
  description = "Minor version update"
}

resource "github_issue_label" "patch" {
  repository  = github_repository.repo.name
  name        = "patch"
  color       = "1d76db"
  description = "Patch version update"
}
