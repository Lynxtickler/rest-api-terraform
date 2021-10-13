variable "rest_api_id" {
  description = "ID of the REST API Gateway."
  type        = string
}

variable "parent_resource_id" {
  description = "ID of the parent resource."
  type        = string
}

variable "methods" {
  description = "Method type and lambda ARN in a map: {method = <method>, lambda = <lambda_arn>}."
  type        = list(map(string))
}

variable "endpoint" {
  description = "Path ending for the resource."
  type        = string
}
