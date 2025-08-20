module "archive" {
  source = "../archive"

  source_dir  = var.source_path
  main_file   = var.filename
  import_file = var.import_file
  name        = var.filename
}

resource "aws_s3_object" "this" {
  bucket = var.bucket_id
  key    = "${var.filename}.zip"
  source = module.archive.output_path
  etag   = filemd5(module.archive.output_path)
}

resource "aws_lambda_function" "this" {
  function_name = var.name
  s3_bucket     = var.bucket_id
  s3_key        = aws_s3_object.this.key

  architectures = ["arm64"]
  runtime = "python3.9"
  handler = "${var.filename}.lambda_handler"

  source_code_hash = module.archive.hash

  role = var.execution_role_arn
}

resource "aws_lambda_permission" "this" {
  count = length(var.api_execution_arns)

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_execution_arns[count.index]}/*/*"
}

resource "aws_lambda_permission" "timer" {
  count = length(var.event_rule_execution_arns)

  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"

  source_arn = var.event_rule_execution_arns[count.index]
}
