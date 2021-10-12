variable "rest_api_id" {
  description = "ID of the REST API Gateway."
  type        = string
}

variable "parent_resource_id" {
  description = "ID of the parent resource."
  type        = string
}

variable "lambda_arn" {
  description = "Lambda function ARN."
  type        = string
}

variable "endpoint" {
  description = "Path ending for the resource."
  type        = string
}

variable "http_method" {
  description = "HTTP method used with this combination."
  type        = string
}
