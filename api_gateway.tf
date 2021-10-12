resource "aws_api_gateway_rest_api" "this" {
  description = "Proxy to handle requests to our API"
  name        = "rest_gateway"
}

module "root_resource" {
  source = "./modules/api_resource"

  rest_api_id        = aws_api_gateway_rest_api.this.id
  parent_resource_id = aws_api_gateway_rest_api.this.root_resource_id
  lambda_arn         = aws_lambda_function.this[1].invoke_arn
  endpoint           = "quotes"
  http_method        = "GET"
}
