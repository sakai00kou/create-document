#-----------------------------------------------------------------------------------------------------------------------
# GitHub Actions用IDプロバイダ
#-----------------------------------------------------------------------------------------------------------------------
data "tls_certificate" "github_provider" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "github_provider" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [
    # data.tls_certificate.github_provider.certificates[0].sha1_fingerprint
    # 仕様変更により証明書サムプリントではなく、信頼されたCAのライブラリを使用して、IdPのサーバー証明書を検証するようになったため
    # レガシーサムプリントは不要となったが、IDプロバイダ作成にはサムプリントが必須のため、ダミーのサムプリントを登録
    "0123456789abcdef0123456789abcdef01234567"
  ]

  tags = {
    Name = "${local.github_id_provider}"
  }
}

#-----------------------------------------------------------------------------------------------------------------------
# GitHub Actions用IAMロール
#-----------------------------------------------------------------------------------------------------------------------
# Assume Role
data "aws_iam_policy_document" "assume_role_create_document" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    principals {
      type        = "Federated"
      identifiers = [
        "${aws_iam_openid_connect_provider.github_provider.arn}"
      ]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [
        "repo:${local.github_account_name}/${local.github_repository}:*"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

# IAM Role
resource "aws_iam_role" "create_document_iam_role" {
  name               = "${local.github_iam_role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_create_document.json}"

  tags = {
    Name = "${local.github_iam_role_name}"
  }
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "create_document_attachment" {
  for_each = {
    readonly = "arn:aws:iam::aws:policy/ReadOnlyAccess",
  }

  role       = "${aws_iam_role.create_document_iam_role.name}"
  policy_arn = each.value
}
