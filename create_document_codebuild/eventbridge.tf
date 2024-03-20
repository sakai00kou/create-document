#-----------------------------------------------------------------------------------------------------------------------
# EventBridge Schedule
#-----------------------------------------------------------------------------------------------------------------------
# ドキュメント作成用CodeBuild実行用スケジュール
resource "aws_scheduler_schedule" "create_document" {
  name                         = "${local.eb_schedule_name}"
  description                  = "${local.eb_schedule_name}"
  group_name                   = "default"
  schedule_expression_timezone = "Asia/Tokyo"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "${local.eb_schedule_cron}"

  target {
    arn      = "${aws_codebuild_project.create_document_proj.arn}"
    role_arn = "${aws_iam_role.eb_schedule_role.arn}"
  }
}
