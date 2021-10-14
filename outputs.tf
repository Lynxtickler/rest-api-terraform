output "invoke_url" {
  value = var.deploy_api ? aws_api_gateway_stage.this[0].invoke_url : null
}
