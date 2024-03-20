#-----------------------------------------------------------------------------------------------------------------------
# Environment
#-----------------------------------------------------------------------------------------------------------------------
resource "github_repository_environment" "create_document" {
  for_each = local.basis_list

  repository  = "${github_repository.create_document_repo.name}"
  environment = each.key
}

#-----------------------------------------------------------------------------------------------------------------------
# Environment環境変数
#-----------------------------------------------------------------------------------------------------------------------
# Secret変数
resource "github_actions_environment_secret" "create_document_secret" {
  for_each = local.basis_list

  repository      = "${github_repository.create_document_repo.name}"
  environment     = each.key
  secret_name     = "AWS_IAM_ROLE_ARN"
  plaintext_value = each.value.iam_role_arn
}

# Variable変数
resource "github_actions_environment_variable" "create_document_variable" {
  for_each = local.basis_list

  repository    = "${github_repository.create_document_repo.name}"
  environment   = each.key
  variable_name = "BASIS_NAME"
  value         = each.value.basis_name
}

#-----------------------------------------------------------------------------------------------------------------------
# Repository環境変数
#-----------------------------------------------------------------------------------------------------------------------
# Variable変数
resource "github_actions_variable" "create_document_variable" {
  repository    = "${github_repository.create_document_repo.name}"
  variable_name = "GH_PAGES_URL"
  value         = "https://${local.github_account_name}.github.io/${local.github_repository}/"
}
