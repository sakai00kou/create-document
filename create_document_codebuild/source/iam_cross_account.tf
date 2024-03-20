#-----------------------------------------------------------------------------------------------------------------------
# クロスアカウントアクセス用IAMロール（相手側アカウントで作成）
#-----------------------------------------------------------------------------------------------------------------------
# Assume Role
data "aws_iam_policy_document" "assume_role_policy_cross_account" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.default_account_id}:role/${local.codebuild_iam_role_name}"]
    }
  }
}

# IAM Role
resource "aws_iam_role" "cross_account_role" {
  name               = "${local.cross_account_A_iam_role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy_cross_account.json}"
  description        = "${local.cross_account_A_iam_role_name}"

  tags = {
    Name = "${local.cross_account_A_iam_role_name}"
  }
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "cross_account_policy_attachment" {
  for_each = {
    readonly  = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }

  role       = "${aws_iam_role.cross_account_role.name}"
  policy_arn = each.value
}
