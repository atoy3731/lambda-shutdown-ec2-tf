resource "aws_cloudwatch_event_rule" "lambda" {
  name                = "run-lambda-function"
  description         = "Schedule lambda function"
  schedule_expression = "cron(${var.cron_schedule})"
}

resource "aws_cloudwatch_event_target" "lambda-function-target" {
  target_id = "lambda-function-target"
  rule      = aws_cloudwatch_event_rule.lambda.name
  arn       = aws_lambda_function.lambda_function.arn
}