resource "aws_api_gateway_rest_api" "this" {
  description = "Proxy to handle requests to our API"
  name        = "rest_gateway"
}

module "quotes_root" {
  source = "./modules/api_resource"

  rest_api_id        = aws_api_gateway_rest_api.this.id
  parent_resource_id = aws_api_gateway_rest_api.this.root_resource_id
  endpoint           = "quotes"
  methods = [
    {
      method = "GET",
      lambda = aws_lambda_function.this[1].invoke_arn
    },
    {
      method = "POST",
      lambda = aws_lambda_function.this[2].invoke_arn
    }
  ]
}

module "quotes_sub" {
  source = "./modules/api_resource"

  rest_api_id        = aws_api_gateway_rest_api.this.id
  parent_resource_id = module.quotes_root.resource_id
  endpoint           = "{id}"
  methods = [
    {
      method = "PUT",
      lambda = aws_lambda_function.this[3].invoke_arn
    },
    {
      method = "DELETE",
      lambda = aws_lambda_function.this[4].invoke_arn
    }
  ]
}
