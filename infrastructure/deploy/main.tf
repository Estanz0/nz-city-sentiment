###########################
# Existing Infrastructure #
###########################

# Subscription
data "azurerm_subscription" "default" {}

# SPN
data "azurerm_client_config" "current" {}

############################
# Terraform Infrastructure #
############################

# Resource Group
resource "azurerm_resource_group" "default" {
  name     = "rg-${var.project_id}-${var.env}-eau"
  location = var.location
}

# Storage Account
resource "azurerm_storage_account" "default" {
  name                     = "st${var.project_id}${var.env}eau001"
  resource_group_name      = azurerm_resource_group.default.name
  location                 = azurerm_resource_group.default.location
  account_tier             = var.st_account_tier
  account_replication_type = var.st_account_replication_type
}

resource "azurerm_storage_table" "default" {
  name                 = "sentiment"
  storage_account_name = azurerm_storage_account.default.name
}

resource "azurerm_storage_queue" "default" {
  name                 = "posts"
  storage_account_name = azurerm_storage_account.default.name
}

resource "azurerm_role_assignment" "default" {
  scope                = azurerm_storage_account.default.id
  role_definition_name = "Storage Table Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "queue" {
  scope                = azurerm_storage_queue.default.id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Github Secrets / Variables
data "github_repository" "repo" {
  full_name = "${var.gh_repo_owner}/${var.gh_repo_name}"
}

resource "github_actions_environment_variable" "action_variable_st_name" {
  repository    = data.github_repository.repo.name
  environment   = var.env
  variable_name = "STORAGE_ACCOUNT_NAME"
  value         = azurerm_storage_account.default.name
}