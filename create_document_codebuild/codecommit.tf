#-----------------------------------------------------------------------------------------------------------------------
# ドキュメント格納用CodeCommitリポジトリ
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_codecommit_repository" "create_document" {
  repository_name = "${local.codecommit_repository}"
  description     = "${local.codecommit_repository}"
  default_branch  = "${local.codecommit_branch_name}"
}
