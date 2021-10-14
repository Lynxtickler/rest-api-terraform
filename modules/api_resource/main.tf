resource "aws_api_gateway_resource" "this" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_resource_id
  path_part   = var.endpoint
}

resource "aws_api_gateway_method" "this" {
  count = length(var.methods)

  rest_api_id   = var.rest_api_id
  resource_id   = aws_api_gateway_resource.this.id
  http_method   = var.methods[count.index].method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "this" {
  count = length(var.methods)

  rest_api_id             = var.rest_api_id
  resource_id             = aws_api_gateway_resource.this.id
  http_method             = aws_api_gateway_method.this[count.index].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.methods[count.index].lambda
}

resource "aws_api_gateway_method_response" "this" {
  count = length(var.methods)

  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.this[count.index].http_method
  status_code = var.methods[count.index].code
}
