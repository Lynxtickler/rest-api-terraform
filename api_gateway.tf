locals {
  deployment_count = var.deploy_api ? 1 : 0
}

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
      lambda = module.api_lambda[1].invoke_arn,
      code   = 200
    },
    {
      method           = "POST",
      lambda           = module.api_lambda[2].invoke_arn,
      code             = 201
      api_key_required = true
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
      method = "GET",
      lambda = module.api_lambda[3].invoke_arn,
      code   = 200
    },
    {
      method           = "PUT",
      lambda           = module.api_lambda[4].invoke_arn,
      code             = 201
      api_key_required = true
    },
    {
      method           = "DELETE",
      lambda           = module.api_lambda[5].invoke_arn,
      code             = 200
      api_key_required = true
    }
  ]
}

module "any" {
  source = "./modules/api_resource"

  rest_api_id        = aws_api_gateway_rest_api.this.id
  parent_resource_id = aws_api_gateway_rest_api.this.root_resource_id
  endpoint           = "{proxy+}"
  methods = [
    {
      method = "ANY",
      lambda = module.api_lambda[0].invoke_arn,
      code   = 404
    }
  ]
}

resource "aws_api_gateway_deployment" "this" {
  count = local.deployment_count

  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  count = local.deployment_count

  deployment_id = aws_api_gateway_deployment.this[count.index].id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = terraform.workspace
}
