# variables.tf

variable "repo_token" {
  description = "GitHub token for managing secrets"
  type        = string
  sensitive   = true
}

variable "repo_owner" {
  description = "GitHub organization or username"
  type        = string
  sensitive   = true
}

variable "repo_name" {
  description = "GitHub repository name"
  type        = string
  sensitive   = true
}

