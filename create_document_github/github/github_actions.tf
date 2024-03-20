#-----------------------------------------------------------------------------------------------------------------------
# Environment
#-----------------------------------------------------------------------------------------------------------------------
resource "github_repository_file" "create_document" {
  for_each = local.workflow_file

  repository          = "${github_repository.create_document_repo.name}"
  branch              = "${local.github_pages_branch}"
  file                = each.value.filepath
  content             = file(each.value.filepath)
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
}