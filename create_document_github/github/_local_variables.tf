#-----------------------------------------------------------------------------------------------------------------------
# GitHub Actions用ローカル変数
#-----------------------------------------------------------------------------------------------------------------------
locals {
  # GitHub基本設定
  github_account_name = "githubaccountname"
  github_repository   = "create-document"
  github_visibility   = "public"
  github_auto_init    = true
  github_archived     = false

  # Pull Request変数
  github_allow_merge_commit          = true
  github_allow_squash_merge          = true
  github_allow_rebase_merge          = true
  github_allow_auto_merge            = false
  github_squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
  github_squash_merge_commit_message = "COMMIT_MESSAGES"
  github_merge_commit_title          = "MERGE_MESSAGE"
  github_merge_commit_message        = "PR_TITLE"
  github_delete_branch_on_merge      = false

  # GitHub Pages変数
  github_pages_build_type = "legacy"
  github_pages_branch     = "main"
  github_pages_path       = "/docs"

  # GitHub Issue、Discussion、Project、Wiki、Download変数
  github_has_issues      = false
  github_has_discussions = false
  github_has_projects    = false
  github_has_wiki        = false
  github_has_downloads   = true

  github_is_template          = false
  github_vulnerability_alerts = false
  github_allow_update_branch  = false

  # コードセキュリティ、アナリティクス変数
  github_secret_scanning                 = "disabled"
  github_secret_scanning_push_protection = "disabled"
}

#-----------------------------------------------------------------------------------------------------------------------
# GitHub Actions用環境変数
#-----------------------------------------------------------------------------------------------------------------------
locals {
  basis_list = {
    system1_dev = {
      iam_role_arn = "arn:aws:iam::123456789012:role/github-create-document-role",
      basis_name   = "System1"
    }
    # --- ここから ---
    # system2_prd = {
    #   iam_role_arn = "arn:aws:iam::987654321098:role/github-create-document-role",
    #   basis_name   = "System2"
    # }
    # --- ここまで ---
  }
}

#-----------------------------------------------------------------------------------------------------------------------
# GitHub Actions Workflowファイル
#-----------------------------------------------------------------------------------------------------------------------
# Workflowファイルを複数作成する場合、Workflowを同時に実行すると、生成物のコミット時に競合が発生し失敗するため、実行時間を変更すること
locals {
  workflow_file = {
    create_document_dev = {
      filepath = ".github/workflows/create_document_dev.yml",
    }
    # --- ここから ---
    # create_document_prd = {
    #   filepath = ".github/workflows/create_document_prd.yml",
    # }
    # --- ここまで ---
  }
}