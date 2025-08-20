output "resource_id" {
  value = aws_api_gateway_resource.this.id
}

output "method_ids" {
  value = [for method in aws_api_gateway_method.this : method.id]
}

output "integration_ids" {
  value = [for integration in aws_api_gateway_integration.this : integration.id]
}
