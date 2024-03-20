#-----------------------------------------------------------------------------------------------------------------------
# EventBridge Schedule用IAMロール
#-----------------------------------------------------------------------------------------------------------------------
# Assume Role
data "aws_iam_policy_document" "assume_role_policy_eb_schedule" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }
  }
}

# IAM Role
resource "aws_iam_role" "eb_schedule_role" {
  name               = "${local.eb_schedule_iam_role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy_eb_schedule.json}"
  description        = "${local.eb_schedule_iam_role_name}"

  tags = {
    Name = "${local.eb_schedule_iam_role_name}"
  }
}

# IAM Policy
data "aws_iam_policy_document" "eb_schedule_policy" {
  statement {
    effect = "Allow"
    actions = [
      "codebuild:StartBuild",
    ]
    resources = [
      "${aws_codebuild_project.create_document_proj.arn}"
    ]
  }
}

resource "aws_iam_policy" "eb_schedule_policy" {
  name        = "${local.eb_schedule_iam_policy_name}"
  path        = "/"
  description = "${local.eb_schedule_iam_policy_name}"
  policy      = "${data.aws_iam_policy_document.eb_schedule_policy.json}"

  tags = {
    Name = "${local.eb_schedule_iam_policy_name}"
  }
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "eb_schedule_policy_attachment" {
  for_each = {
    eb_schedule = "${aws_iam_policy.eb_schedule_policy.arn}"
  }

  role       = "${aws_iam_role.eb_schedule_role.name}"
  policy_arn = each.value
}

#-----------------------------------------------------------------------------------------------------------------------
# CodeBuild用IAMロール
#-----------------------------------------------------------------------------------------------------------------------
# Assume Role
data "aws_iam_policy_document" "codebuild_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

# IAM Role
resource "aws_iam_role" "codebuild_iam_role" {
  name               = "${local.codebuild_iam_role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.codebuild_assume_role_policy.json}"

  tags = {
    Name = "${local.codebuild_iam_role_name}"
  }
}

# IAM Policy
data "aws_iam_policy_document" "codebuild_iam_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${local.codebuild_log_group_name}",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${local.codebuild_log_group_name}:*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages"
    ]
    resources = [
      "${aws_codebuild_project.create_document_proj.arn}",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:RestoreObject"
    ]
    resources = [
      "${aws_s3_bucket.bucket.arn}",
      "${aws_s3_bucket.bucket.arn}/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "codecommit:Get*",
      "codecommit:List*",
      "codecommit:CreateBranch",
      "codecommit:CreateCommit",
      "codecommit:CreatePullRequest",
      "codecommit:CreatePullRequestApprovalRule",
      "codecommit:DeleteBranch",
      "codecommit:DeleteCommentContent",
      "codecommit:DeleteFile",
      "codecommit:DeletePullRequestApprovalRule",
      "codecommit:GitPush",
      "codecommit:OverridePullRequestApprovalRules",
      "codecommit:PostCommentForPullRequest",
      "codecommit:PutFile",
      "codecommit:UpdateComment",
      "codecommit:UpdatePullRequestApprovalRuleContent",
      "codecommit:UpdatePullRequestApprovalState",
      "codecommit:UpdatePullRequestDescription",
      "codecommit:UpdatePullRequestStatus",
      "codecommit:UpdatePullRequestTitle",
      "codecommit:UploadArchive",
    ]
    resources = [
      "${aws_codecommit_repository.create_document.arn}",
    ]
  }
  # クロスアカウントのIAMロールを使用する場合に有効にする
  # --- ここから ---
  # statement {
  #   effect = "Allow"
  #   actions = [
  #     "sts:AssumeRole",
  #   ]
  #   resources = [
  #     "arn:aws:iam::${local.cross_account_A_account_id}:role/${local.cross_account_A_iam_role_name}"
  #   ]
  # }
  # --- ここまで ---
}

resource "aws_iam_policy" "codebuild_iam_policy" {
  name   = "${local.codebuild_iam_policy_name}"
  path   = "/"
  policy = "${data.aws_iam_policy_document.codebuild_iam_policy.json}"

  tags = {
    Name = "${local.codebuild_iam_policy_name}"
  }
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
  for_each = {
    readonly  = "arn:aws:iam::aws:policy/ReadOnlyAccess",
    codebuild = "${aws_iam_policy.codebuild_iam_policy.arn}",
  }

  role       = "${aws_iam_role.codebuild_iam_role.name}"
  policy_arn = each.value
}
