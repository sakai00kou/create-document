#-----------------------------------------------------------------------------------------------------------------------
# GitHub Actions用リポジトリ
#-----------------------------------------------------------------------------------------------------------------------
resource "github_repository" "create_document_repo" {
  # GitHub基本設定
  name        = "${local.github_repository}"
  description = "${local.github_repository}"
  visibility  = "${local.github_visibility}"
  auto_init   = "${local.github_auto_init}"
  archived    = "${local.github_archived}"

  # Pull Request設定
  allow_merge_commit          = "${local.github_allow_merge_commit}"
  allow_squash_merge          = "${local.github_allow_squash_merge}"
  allow_rebase_merge          = "${local.github_allow_rebase_merge}"
  allow_auto_merge            = "${local.github_allow_auto_merge}"
  squash_merge_commit_title   = "${local.github_squash_merge_commit_title}"
  squash_merge_commit_message = "${local.github_squash_merge_commit_message}"
  merge_commit_title          = "${local.github_merge_commit_title}"
  merge_commit_message        = "${local.github_merge_commit_message}"
  delete_branch_on_merge      = "${local.github_delete_branch_on_merge}"

  # GitHub Pages設定
  pages {
    build_type = "${local.github_pages_build_type}"

    source {
      branch = "${local.github_pages_branch}"
      path   = "${local.github_pages_path}"
    }
  }

  # GitHub Issue、Discussion、Project、Wiki、Download設定
  has_issues           = "${local.github_has_issues}"
  has_discussions      = "${local.github_has_discussions}"
  has_projects         = "${local.github_has_projects}"
  has_wiki             = "${local.github_has_wiki}"
  has_downloads        = "${local.github_has_downloads}"

  is_template          = "${local.github_is_template}"
  vulnerability_alerts = "${local.github_vulnerability_alerts}"
  allow_update_branch  = "${local.github_allow_update_branch}"

  # コードセキュリティ、アナリティクス設定
  security_and_analysis {
    secret_scanning {
      status = "${local.github_secret_scanning}"
    }
    secret_scanning_push_protection {
      status = "${local.github_secret_scanning_push_protection}"
    }
  }
}
