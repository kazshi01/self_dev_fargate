resource "aws_lambda_function" "slack_approval" {
  function_name = "slackApproval"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "slack.lambda_handler" # slack.pyのlambda_handler関数を指定
  runtime       = "python3.8"

  filename         = "./slack_notifier/slack_function.zip"                   # 手元のZIPファイルのパス
  source_code_hash = filebase64sha256("./slack_notifier/slack_function.zip") # ソースコードが変更されたときにのみ更新をトリガーするためのパラメータ

  timeout     = 30  # タイムアウトを30秒に設定
  memory_size = 256 # メモリサイズを256MBに設定
}
