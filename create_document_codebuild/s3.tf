#-----------------------------------------------------------------------------------------------------------------------
# 生成ドキュメント格納用S3バケット
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "bucket" {
  bucket = "${local.s3_bucket_name}"

  tags = {
    Name = "${local.s3_bucket_name}"
  }
}

# バージョニングの設定
# S3バケットに格納するドキュメントはCodeCommitで管理されているため、S3のバージョニングは無効にする
resource "aws_s3_bucket_versioning" "bucket" {
  bucket = "${local.s3_bucket_name}"
  versioning_configuration {
    status = "Disabled"
  }
}

# サーバー側の暗号化
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket" {
  bucket = "${local.s3_bucket_name}"
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = "${local.s3_bucket_name}"

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# resource "aws_s3_bucket_lifecycle_configuration" "bucket" {
#   bucket = "${local.s3_bucket_name}"

#   rule {
#     id     = "delete_s3_logging"
#     status = "Enabled"
#     expiration {
#       days = 365
#     }

#     filter {
#       prefix = "*"
#     }

#     noncurrent_version_expiration {
#       noncurrent_days           = 1
#       newer_noncurrent_versions = 3
#     }

#     abort_incomplete_multipart_upload {
#       days_after_initiation = 7
#     }
#   }
# }

resource "aws_s3_bucket_ownership_controls" "bucket" {
  depends_on = [aws_s3_bucket.bucket]
  bucket     = "${local.s3_bucket_name}"

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# 静的Webサイトホスティング
resource "aws_s3_bucket_website_configuration" "bucket" {
  bucket = "${aws_s3_bucket.bucket.id}"

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# バケットポリシー
resource "aws_s3_bucket_policy" "bucket" {
  depends_on = [
    aws_s3_bucket_public_access_block.bucket,
    aws_s3_bucket_ownership_controls.bucket,
  ]
  bucket = "${aws_s3_bucket.bucket.id}"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = {
          "AWS":"*"
        }
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.bucket.arn}/*"
        # アドレス制限する場合に有効にする
        # Condition = {
        #   IpAddress = {
        #     "aws:SourceIp" = [
        #       "192.0.2.1/32",
        #       "198.51.100.1/32",
        #     ]
        #   }
        # }
      }
    ]
  })
}
