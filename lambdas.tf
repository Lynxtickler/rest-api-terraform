resource "random_pet" "lambda_bucket_name" {
  prefix = "ties4560-functions"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id

  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "lambda_bucket" {
  bucket = aws_s3_bucket.lambda_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "lambda_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.lambda_bucket]

  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

module "api_lambda" {
  source = "./modules/lambda"
  count  = length(var.lambdas)

  name               = var.lambdas[count.index].name
  source_path        = var.source_path
  filename           = var.lambdas[count.index].filename
  import_file        = var.import_file
  bucket_id          = aws_s3_bucket.lambda_bucket.id
  execution_role_arn = aws_iam_role.lambda_exec.arn
  api_execution_arns = [aws_api_gateway_rest_api.this.execution_arn]
}

module "timer_lambda" {
  source = "./modules/lambda"

  name                      = "daily-quote"
  source_path               = var.source_path
  filename                  = "daily-quote"
  import_file               = var.import_file
  bucket_id                 = aws_s3_bucket.lambda_bucket.id
  execution_role_arn        = aws_iam_role.lambda_exec.arn
  event_rule_execution_arns = [aws_cloudwatch_event_rule.this.arn]
}
