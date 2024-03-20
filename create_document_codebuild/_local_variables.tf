#-----------------------------------------------------------------------------------------------------------------------
# タグ用変数
#-----------------------------------------------------------------------------------------------------------------------
locals {
  env             = "dev"
  project_name    = "system1"
  role            = "create_document"
  resource_prefix = "${local.project_name}-${local.env}"
}

#-----------------------------------------------------------------------------------------------------------------------
# S3バケット用ローカル変数
#-----------------------------------------------------------------------------------------------------------------------
locals {
  s3_bucket_name = "create-document"
}

#-----------------------------------------------------------------------------------------------------------------------
# CodeCommit用ローカル変数
#-----------------------------------------------------------------------------------------------------------------------
locals {
  codecommit_repository  = "create-document"
  codecommit_branch_name = "master"
}

#-----------------------------------------------------------------------------------------------------------------------
# CodeBuild用ローカル変数
#-----------------------------------------------------------------------------------------------------------------------
locals {
  codebuild_proj_name       = "create-document-proj"
  codebuild_iam_role_name   = "codebuild-create-document-role"
  codebuild_iam_policy_name = "codebuild-create-document-policy"
  codebuild_log_group_name  = "/aws/codebuild/create-document-codebuild"
  codebuild_log_stream_name = "create-document"
  codebuild_retention_days  = 7
}

#-----------------------------------------------------------------------------------------------------------------------
# EventBridge Schedule用ローカル変数
#-----------------------------------------------------------------------------------------------------------------------
locals {
  eb_schedule_name            = "create-document-schedule"
  eb_schedule_cron            = "cron(0 2 * * ? *)"
  eb_schedule_iam_role_name   = "eb-schedule-create-document-role"
  eb_schedule_iam_policy_name = "eb-schedule-create-document-policy"
}

#-----------------------------------------------------------------------------------------------------------------------
# CodeBuild、ドキュメント作成シェル用ローカル変数
#-----------------------------------------------------------------------------------------------------------------------
locals {
  # AWS CLI用glibcバージョンの指定は以下リリースページのリリース番号を指定する。
  # https://github.com/sgerrand/alpine-pkg-glibc/releases
  aws_cli_install_glibc_version    = "2.35-r1"
  create_document_src_dir          = "docs"
  create_document_protocol         = "http"
  create_document_basis_name       = "System1"
  create_document_environment_name = "dev"
  create_document_proj_name        = "TestProject"
  codecommit_mail_address          = "codebuild@amazonaws.com"
  codecommit_user_name             = "CodeBuild"
}

#-----------------------------------------------------------------------------------------------------------------------
# クロスアカウント用ローカル変数（クロスアカウントで情報取得する場合に設定）
#-----------------------------------------------------------------------------------------------------------------------
# --- ここから ---
# locals {
#   default_account_id               = "123456789012"
#   cross_account_A_profile_name     = "cross-account-A"
#   cross_account_A_account_id       = "987654321098"
#   cross_account_A_iam_role_name    = "cross-account-create-document-role"
#   cross_account_A_basis_name       = "System2"
#   cross_account_A_environment_name = "dev"
# }
# --- ここまで ---
