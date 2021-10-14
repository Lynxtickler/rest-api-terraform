resource "aws_cloudwatch_event_rule" "this" {
  name                = "run-daily"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "this" {
  rule      = aws_cloudwatch_event_rule.this.name
  target_id = "lambda"
  arn       = module.timer_lambda.arn
}
