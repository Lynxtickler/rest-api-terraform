resource "aws_cloudwatch_event_rule" "this" {
  name                = "run-daily"
  schedule_expression = "cron(0 6 ? * * *)"
}

resource "aws_cloudwatch_event_target" "this" {
  rule      = aws_cloudwatch_event_rule.this.name
  target_id = "lambda"
  arn       = module.timer_lambda.arn
}
