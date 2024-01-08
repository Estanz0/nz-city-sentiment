# General
variable "project_id" {
  type = string
}

variable "env" {
  type = string
}

variable "location" {
  type = string
}

# SPN
variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

# Github
variable "gh_repo_owner" {
  type = string
}

variable "gh_repo_name" {
  type = string
}

# Storage Account
variable "st_account_tier" {
  type = string
}

variable "st_account_replication_type" {
  type = string
}