resource "random_pet" "lambda_bucket_name" {
  prefix = "ties4560-functions"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id

  acl           = "private"
  force_destroy = true
}

data "archive_file" "this" {
  count = length(var.lambdas)

  type        = "zip"
  source_file = "${path.module}/${var.source_path}/${var.lambdas[count.index].filename}.py"
  output_path = "${path.module}/${var.source_path}/${var.lambdas[count.index].filename}.zip"
}

resource "aws_s3_bucket_object" "lambda_root" {
  count = length(var.lambdas)

  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "${var.lambdas[count.index].filename}.zip"
  source = data.archive_file.this[count.index].output_path
  etag   = filemd5(data.archive_file.this[count.index].output_path)
}

resource "aws_lambda_function" "this" {
  count = length(var.lambdas)

  function_name = var.lambdas[count.index].name
  s3_bucket     = aws_s3_bucket.lambda_bucket.id
  s3_key        = aws_s3_bucket_object.lambda_root[count.index].key

  runtime = "python3.9"
  handler = "${var.lambdas[count.index].filename}.lambda_handler"

  source_code_hash = data.archive_file.this[count.index].output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_permission" "this" {
  count = length(var.lambdas)

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this[count.index].function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}
