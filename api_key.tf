data "aws_ssm_parameter" "api_key" {
  name = var.api_key_ssm_parameter
}

resource "aws_api_gateway_api_key" "this" {
  name  = "quotes-api-key"
  value = data.aws_ssm_parameter.api_key.value
}

resource "aws_api_gateway_usage_plan" "this" {
  count = local.deployment_count

  name = "quotes-api-plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.this.id
    stage  = aws_api_gateway_stage.this[0].stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "this" {
  count = local.deployment_count

  key_id        = aws_api_gateway_api_key.this.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.this[0].id
}
